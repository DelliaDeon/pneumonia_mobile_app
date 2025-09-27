import 'dart:io';
import 'dart:typed_data';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:image/image.dart' as img;  // for image manipulation
import 'package:tflite_flutter/tflite_flutter.dart';


class OfflinePredService {
  // model interpreter
  Interpreter? _interpreter;

  final List<String> _labels = [
    'Bacterial Pneumonia',
    'Non X-ray',
    'Normal',
    'Viral Pneumonia'
  ];

  OfflinePredService();

  // function to load model when called
  Future<void> loadModel(String modelPath) async{
    try {
      _interpreter = await Interpreter.fromAsset(modelPath);
      print("Model Loaded Successfully: ${_interpreter?.getInputTensor(0).shape}");
    } catch (e){
      print("Error Loading Model: $e");
      rethrow;
    }
  }

  // dispose method to close the interpreter
  void dispose(){
    _interpreter?.close();
    _interpreter = null;  // clear the reference
  }

  // function to preprocess image to match the model's input
  Uint8List preprocessImage(Uint8List imageBytes){
    // decode image bytes using 'image' package
    img.Image? originalImage = img.decodeImage(imageBytes);

    if (originalImage == null){
      throw Exception("Could not decode message");
    }

    if (_interpreter == null) {
      throw Exception("Interpreter not loaded for preprocessing");
    }

    // get input tensor to know expected size
    final inputShape = _interpreter!.getInputTensor(0).shape;
    final inputHeight = inputShape[1];
    final inputWidth = inputShape[2];

    // resize image to get model's input size
    img.Image resizedImage = img.copyResize(originalImage,
      width: inputWidth, height: inputHeight);

    // because the model takes a float value between 0 and 1:
    final Float32List normalizedBytes = Float32List(
      1 * inputHeight * inputWidth * 3);
    int index = 0;
    for (int y = 0; y < inputHeight; y++) {
      for (int x = 0; x < inputWidth; x++) {
        img.Pixel pixel = resizedImage.getPixel(x, y);
        normalizedBytes[index++] = pixel.r / 255.0;
        normalizedBytes[index++] = pixel.g / 255.0;
        normalizedBytes[index++] = pixel.b / 255.0;
      }
    }
    return normalizedBytes.buffer.asUint8List();

  }

  // prepare input, output and interpreter
  Future<Map<String, dynamic>?> runInference(Uint8List preprocessedBytes) async {
    if (_interpreter == null){
      throw Exception("Interpreter not loaded");
    }

    // get input and output tensor details
    final inputTensor = _interpreter!.getInputTensor(0);
    final outputTensor = _interpreter!.getOutputTensor(0);

    // ensure preprocessed bytes match input tensor's size
    if (preprocessedBytes.lengthInBytes != inputTensor.numBytes()){
      throw Exception("Preprocessed Image Size Does not Match Model Input's");
    }

    // convert preprocessedImage from Uint8List to Float32List
    final Float32List inputFloatBuffer = preprocessedBytes.buffer.asFloat32List();

    var input = inputFloatBuffer.reshape([
      1, // batch size
      inputTensor.shape[1],  // Height
      inputTensor.shape[2],  // Width
      inputTensor.shape[3],  // Channels
    ]);

    var output = List.filled(outputTensor.numElements(),
        0.0).reshape(outputTensor.shape);

    // run inference
    _interpreter!.run(input, output);

    // process the output
    List<double> probabilities = output[0].cast<double>();

    // get highest probability
    int predictedClassIndex = probabilities.indexOf(probabilities.reduce((a, b) => a > b ? a : b));
    double maxProbability = probabilities[predictedClassIndex];

    if (predictedClassIndex != -1 && predictedClassIndex < _labels.length) {
      Map<String, dynamic> result = {};

      // Top prediction
      result['prediction'] = _labels[predictedClassIndex];
      result['confidence'] = maxProbability;

      // Add all class confidences
      Map<String, double> allConfidences = {};
      for (int i = 0; i < probabilities.length; i++) {
        allConfidences[_labels[i]] = probabilities[i];
      }
      result['all_confidences'] = allConfidences;

      // GradCAM not supported offline
      result['gradcam'] = null;

      return result;
    }
    return null;
  }
}
