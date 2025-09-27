import 'package:final_year_p/logic/prediction_service.dart';
import 'package:flutter/material.dart';
import 'dart:typed_data';
import 'dart:convert';

class PredictionPage extends StatefulWidget {
  final String filename;
  final Uint8List imageBytes;

  const PredictionPage({
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
  Map<String, double>? allConfidences;
  bool showConfidences = false;

  // NEW: Add status tracking
  String statusMessage = 'Initializing...';
  int currentAttempt = 0;
  int totalAttempts = 10;

  @override
  void initState() {
    super.initState();
    uploadAndPredict();
  }

  Future<void> uploadAndPredict() async {
    try {
      setState(() {
        statusMessage = 'Waking up server...';
        currentAttempt = 1;
      });

      // send image and wait for response from FastAPI
      final response = await PredictionService.predictImage(
        imageBytes: widget.imageBytes,
        filename: widget.filename,
        onAttempt: (attempt, total) {
          // Callback to update UI with attempt info
          setState(() {
            currentAttempt = attempt;
            totalAttempts = total;
            if (attempt == 1) {
              statusMessage = 'Sending image for analysis...';
            } else {
              statusMessage = 'Server is waking up...\nAttempt $attempt of $total\nThis may take 30-60 seconds';
            }
          });
        },
      );

      debugPrint("Response received");

      setState(() {
        prediction = response['prediction'];
        debugPrint(prediction);
        // Ensure confidence is parsed correctly, default to 0.0 if null
        confidence = response['confidence'] ?? 0.0;
        debugPrint(confidence.toString());

        if (response['all_confidences'] != null) {
          allConfidences = Map<String, double>.from(
            response['all_confidences']
                .map((k, v) => MapEntry(k, (v as num).toDouble())),
          );
        }

        if (response['gradcam'] != null) {
          // Decode the base64 string. The '.split(',').last' is for handling
          // potential 'data:image/png;base64,' prefixes from the backend.
          gradcamImage = base64Decode(response['gradcam'].split(',').last);
          debugPrint("Gradcam retrieved");
        }
        loading = false;
        statusMessage = 'Analysis complete!';
      });
    } catch (e) {
      setState(() {
        error = e.toString();
        loading = false;
        statusMessage = 'Analysis failed';
      });
      // For debugging, print the full error
      debugPrint('Error in uploadAndPredict: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      ),
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Center(
          child: loading
              ? _buildLoadingState() // Updated loading state
              : error != null
              ? _buildErrorState() // Updated error state
              : _buildResultsState(), // Results state
        ),
      ),
    );
  }

  Widget _buildLoadingState() {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 20),
          Text(
            statusMessage,
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
          if (currentAttempt > 1) ...[
            const SizedBox(height: 10),
            Text(
              'Attempt $currentAttempt of $totalAttempts',
              style: const TextStyle(
                fontSize: 16,
                color: Colors.orange,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'The server is waking up from inactivity.\nThis is normal and may take 30-60 seconds.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
          ],
          const SizedBox(height: 20),
          // Show the original image while loading
          Column(
            children: [
              const Text(
                'Original Image',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 10),
              Image.memory(widget.imageBytes, height: 224),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState() {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 60, color: Colors.red),
          const SizedBox(height: 20),
          Text(
            "Analysis Failed",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 24,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            error ?? "Unknown error occurred",
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontSize: 16,
              color: Colors.red,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: uploadAndPredict,
            child: const Text('Try Again'),
          ),
          const SizedBox(height: 20),
          // Show the original image
          Column(
            children: [
              const Text(
                'Original Image',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 10),
              Image.memory(widget.imageBytes, height: 224),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildResultsState() {
    return Padding(
      padding: const EdgeInsets.all(25.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              const Text(
                'Original Image',
                style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 10),
              Image.memory(widget.imageBytes, height: 224),
            ],
          ),
          const SizedBox(height: 30),

          Text(
            "Prediction: $prediction",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 12),

          Text(
            "Confidence: ${(confidence! * 100).toStringAsFixed(2)}%",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 40),

          if (prediction == "Class 1" || prediction == "Non X-ray")
            Column(
              children: const [
                Icon(Icons.warning_amber_rounded, size: 60, color: Colors.redAccent),
                SizedBox(height: 15),
                Text(
                  "This image is not a chest X-ray.\n\nPlease upload a valid chest X-ray image for diagnosis.",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                ),
              ],
            )
          else ...[
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
              const SizedBox(height: 30),
            ],

            if (gradcamImage != null)
              Column(
                children: [
                  const Text(
                    'Grad-CAM',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 30,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  const Text(
                    "Grad-CAM (Gradient-weighted Class Activation Mapping)"
                        "provides insights into which parts of an input image contribute"
                        "the most to a specific prediction made by the model.",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Image.memory(gradcamImage!, height: 224),
                ],
              ),
            const SizedBox(height: 20),

            const Text(
              "Brightest and warmest colors like red and yellow show the parts "
                  "the model focuses on more. Blue and green shows the parts that "
                  "influences the model's decision the most.",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ],
      ),
    );
  }
}