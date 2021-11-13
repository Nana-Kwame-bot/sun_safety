import 'dart:convert';
import 'package:flutter/foundation.dart';
import '../models/uv.dart';
import 'package:http/http.dart' as http;

// A function that converts a response body into Sunshine :) .
UV _parseJson(String responseBody) {
  final parsedJson = jsonDecode(responseBody);

  return UV.fromJson(parsedJson);
}

/// Exception thrown when uvSearch fails.
class UVIRequestFailure implements Exception {}

class UVapiClient {
  UVapiClient({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  static const _baseUrl = 'https://api.openuv.io';
  final http.Client _httpClient;

  Future<UV> fetchData({
    required http.Client client,
    required double latitude,
    required double longitude,
  }) async {
    final _uvRequest = Uri.https(
      _baseUrl,
      '/api/v1/forecast',
      <String, dynamic>{
        'lat': latitude,
        'lng': longitude,
        'dt': DateTime.now().toIso8601String()
      },
    );

    final _uvResponse = await _httpClient.get(_uvRequest);

    if (_uvResponse.statusCode != 200) {
      debugPrint(_uvResponse.statusCode.toString() + "Failure");
      throw UVIRequestFailure();
    }

    debugPrint(_uvResponse.request.toString());
    // Use the compute function to run _parseJson in a separate isolate.
    return compute(_parseJson, _uvResponse.body);
  }
}
