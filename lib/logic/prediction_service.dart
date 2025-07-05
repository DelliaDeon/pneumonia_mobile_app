import 'package:flutter/material.dart';
import 'package:http_parser/http_parser.dart';
import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:mime/mime.dart';

class PredictionService {
  static Future<Map<String, dynamic>> predictImage({
    required Uint8List imageBytes,
    required String filename,
  }) async {
    final uri = Uri.parse('http://127.0.0.1:8000/predict');

    final request = http.MultipartRequest('POST', uri);

    // allow both png and jpeg
    final mimeType = lookupMimeType(filename);
    final contentType = mimeType != null
      ? MediaType.parse(mimeType)
      : MediaType('image', 'png');

    // create a field name "file" to match file in FastAPI code
    final multipartFile = http.MultipartFile.fromBytes(
      'file',
      imageBytes,
      filename: filename,
      contentType: contentType,
    );

    // add file to the request
    request.files.add(multipartFile);

    final streamedResponse = await request.send();
    final responseBody = await streamedResponse.stream.bytesToString();

    if (streamedResponse.statusCode != 200){
      throw Exception("Prediction Failed: $responseBody");
    }

    return json.decode(responseBody);
  }
}