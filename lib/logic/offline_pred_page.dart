import 'dart:io';
import 'package:final_year_p/logic/image_helper.dart';
import 'package:final_year_p/logic/tflite_logic.dart';
import 'package:flutter/material.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'dart:typed_data';
import 'dart:convert';


class OfflinePredictionPage extends StatefulWidget {
  final String filename;
  final Uint8List imageBytes;

  OfflinePredictionPage({
    super.key,
    required this.filename,
    required this.imageBytes,
  });

  @override
  State<OfflinePredictionPage> createState() => _OfflinePredictionPageState();
}


class _OfflinePredictionPageState extends State<OfflinePredictionPage> {
  String? prediction;
  double? confidence;
  Uint8List? gradcamImage;
  bool loading = true;
  String? error;
  Map<String, double>? allConfidences;
  bool showConfidences = false;


  // instance of prediction service
  late OfflinePredService _offlinePredService;

  @override
  void initState() {
    super.initState();
    _offlinePredService = OfflinePredService();  // initialize the service
    _initAndPredict();
  }

  // function to intialize model and make predictions
  Future<void> _initAndPredict() async{
    try{
      setState(() {
        loading = true;
        prediction = "Loading model...";
      });

      // load model
      await _offlinePredService.loadModel("lib/assets/model.tflite");

      // run the prediction
      final response = await _offlinePredService.runInference(
        _offlinePredService.preprocessImage(widget.imageBytes)
      );

      setState(() {
        if (response != null) {
          prediction = response['prediction'];
          confidence = response['confidence'];

          if (response['all_confidences'] != null) {
            allConfidences = Map<String, double>.from(
              response['all_confidences']
                  .map((k, v) => MapEntry(k, (v as num).toDouble())),
            );
          }

          if (gradcamImage != null){
            gradcamImage = base64Decode(response['gradcam'].split(',').last);
          }
          gradcamImage = null;
        } else {
          error = "Prediction returned no result.";
        }
        loading = false;
      });
    } catch (e){
      setState(() {
        error = "Failed to load model or predict: $e";
        loading = false;
      });
      print("Error: $e");
    }
  }

  @override
  void dispose() {
    // close the interpreter when the widget is disposed
    _offlinePredService.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    double originalWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        backgroundColor:  Theme.of(context).scaffoldBackgroundColor,
      ),
      backgroundColor: Colors.blueGrey.shade50,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: loading
                ? CircularProgressIndicator()
                : error != null
                ? Text("Error: $error")
                :Padding(
              padding: const EdgeInsets.all(25.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      SizedBox(height: 20,),

                      Center(
                        child: Image.memory(
                          widget.imageBytes, height: 224,
                        )
                      ),
                    ],
                  ),
                  SizedBox(height: 20,),


                  Text("Prediction: $prediction",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 22,
                    ),
                  ),
                  SizedBox(height: 12,),
        
                  Text(
                    "Confidence: ${(confidence! * 100).toStringAsFixed(2)}%",
                    style: TextStyle(
                      fontWeight: FontWeight.w400,
                      color: Colors.grey.shade800,
                      fontSize: 20,
                    ),
                  ),
                  SizedBox(height: 30,),

                  if (prediction == "Class 1" ||
                      prediction == "Non X-ray") ...[
                    const Icon(
                      Icons.warning_amber_rounded,
                      size: 60,
                      color: Colors.redAccent,
                    ),
                    const SizedBox(height: 15),
                    const Text(
                      "This image is not a chest X-ray.\n\nPlease upload a valid chest X-ray image for diagnosis.",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.redAccent,
                      ),
                    ),
                  ] else ...[
                    if (allConfidences != null) ...[
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            showConfidences = !showConfidences;
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue.shade800,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        child: Text(showConfidences ? "Hide Confidences" : "View All Confidences"),
                      ),
                      const SizedBox(height: 10),

                      // Drop-down content
                      if (showConfidences)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: allConfidences!.entries.map((entry) {
                            return Padding(
                              padding: const EdgeInsets.symmetric(vertical: 4.0),
                              child: Text(
                                "${entry.key}: ${(entry.value * 100).toStringAsFixed(2)}%",
                                style: const TextStyle(fontSize: 18),
                              ),
                            );
                          }).toList(),
                        ),
                      const SizedBox(height: 30), // Added const
                    ],

                    Text("Go Online For Grad-CAM (Gradient-weighted Class Activation Mapping) Visualization. "
                      "It helps to interpret and understand the decisions made by the model." ,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  SizedBox(height: 30,),
        
                  if (gradcamImage != null)
                    Column(
                      children: [
                        Text('Grad-CAM'),
                        Image.memory(gradcamImage!, height: 224,),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
