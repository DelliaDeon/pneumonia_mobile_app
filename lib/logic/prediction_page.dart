import 'package:final_year_p/logic/prediction_service.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;


class PredictionPage extends StatefulWidget {
  final String filename;
  final Uint8List imageBytes;

  PredictionPage({
    super.key,
    required this.filename,
    required this.imageBytes,
  });

  @override
  State<PredictionPage> createState() => _PredictionPageState();
}

class _PredictionPageState extends State<PredictionPage> {
  String? prediction;
  double? confidence;
  Uint8List? gradcamImage;
  bool loading = true;
  String? error;

  @override
  void initState() {
    super.initState();
    uploadAndPredict();
  }

  Future<void> uploadAndPredict() async {
    try {
      // send image and wait for response from FastAPI
      final response = await PredictionService.predictImage(
        imageBytes: widget.imageBytes,
        filename: widget.filename,
      );
      setState(() {
        prediction = response['prediction'];
        confidence = response['confidence'] ?? 0.0;

        if (response['gradcam'] != null){
          gradcamImage = base64Decode(response['gradcam'].split(',').last);
        }
        loading = false;
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        loading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    double originalWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(),
      backgroundColor: Colors.blue.shade100,
      body: SingleChildScrollView(
        child: Center(
          child: loading
            ? CircularProgressIndicator()
            : error != null
              ? Text("Error: $error")
              :Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
        
                    Column(
                      children: [
                        Text('Original Image'),
                        Image.memory(widget.imageBytes, height: originalWidth * 0.3,),
                      ],
                    ),
        
                    SizedBox(height: 20,),
        
                    Text("Prediction: $prediction", style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                    ),),
                    Text("Confidence: ${(confidence! * 100).toStringAsFixed(2)}%"),
                    SizedBox(height: 20,),
        
        
                    Text("Grad-CAM (Gradient-weighted Class Activation Mapping) is a "
                        "visualization technique used in deep learning to help "
                        "interpret and understand the decisions made by convolutional neural networks (CNNs)." ,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
        
                    Text("It provides insights into which parts of an input image are "
                        "most important for a specific prediction made by the model. "
                        "By highlighting the regions in an image that contribute the "
                        "most to the model’s output, helping users understand the basis "
                        "for a model’s predictions." ,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: 20,),
        
        
                    if (gradcamImage != null)
                      Column(
                        children: [
                          Text('Grad-CAM'),
                          Image.memory(gradcamImage!, height: 224,),
                        ],
                      ),
        
                    Text("Brightest and warmest colors like red and yellow show the parts "
                        "the model focuses on more. Blue and green shows the parts that "
                        "influences the model's decision the most." ,
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
        
                  ],
                        ),
              ),
        ),
      ),
    );
  }
}

