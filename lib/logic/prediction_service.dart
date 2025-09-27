import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

class PredictionService {
  static const String baseUrl = 'https://pneumonia-backend-5.onrender.com';
  static const int maxRetries = 10;
  static const Duration initialDelay = Duration(seconds: 10);

  static Future<Map<String, dynamic>> predictImage({
    required Uint8List imageBytes,
    required String filename,
    required Function(int attempt, int total)? onAttempt,
  }) async {
    // try to wake up the server with a simple GET request
    await _wakeUpServer();

    // attempt the prediction with retry logic
    for (int attempt = 1; attempt <= maxRetries; attempt++) {
      if (onAttempt != null) {
        onAttempt(attempt, maxRetries);
      }
      try {
        print('Prediction attempt $attempt of $maxRetries');

        final response = await _sendPredictionRequest(
          imageBytes: imageBytes,
          filename: filename,
          attempt: attempt,
        );

        return response;

      } catch (e) {
        print('Attempt $attempt failed: $e');

        if (attempt == maxRetries) {
          throw Exception('Prediction failed after $maxRetries attempts: $e');
        }

        // longer between each retry (10s, 20s, 30s)
        await Future.delayed(initialDelay * attempt);

        // wake up server again before next attempt
        if (attempt < maxRetries) {
          await _wakeUpServer();
        }
      }
    }

    throw Exception('Unexpected error: Prediction failed');
  }

  static Future<void> _wakeUpServer() async {
    final client = http.Client();
    try {
      print('Waking up server...');
      final response = await client.get(
        Uri.parse('$baseUrl/'),
      ).timeout(
        Duration(seconds: 30),
        onTimeout: () {
          print('Wake-up call timed out (server is likely waking up)');
          return http.Response('', 408); // Return a timeout response
        },
      );
      print('Server wake-up status: ${response.statusCode}');
      await Future.delayed(Duration(seconds: 2)); // Give server time to initialize
    } catch (e) {
      print('Wake-up call error (normal during spin-up): $e');
    } finally {
      client.close();
    }
  }

  static Future<Map<String, dynamic>> _sendPredictionRequest({
    required Uint8List imageBytes,
    required String filename,
    required int attempt,
  }) async {
    final client = http.Client();
    try {
      final uri = Uri.parse('$baseUrl/predict');
      final request = http.MultipartRequest('POST', uri);

      final multipartFile = http.MultipartFile.fromBytes(
        'file',
        imageBytes,
        filename: filename,
      );
      request.files.add(multipartFile);

      // Increase timeout for later attempts (server might be slower to wake up)
      final timeoutSeconds = attempt == 1 ? 60 : 90;

      print('Sending prediction request (timeout: ${timeoutSeconds}s)...');

      final response = await client.send(request).timeout(
        Duration(seconds: timeoutSeconds),
        onTimeout: () => throw TimeoutException('Prediction request timed out after ${timeoutSeconds}s'),
      );

      if (response.statusCode == 200) {
        final body = await response.stream.bytesToString();
        final result = json.decode(body);
        print('Prediction successful on attempt $attempt');
        return result;
      } else {
        throw Exception('HTTP ${response.statusCode}: Prediction failed');
      }
    } finally {
      client.close();
    }
  }
}