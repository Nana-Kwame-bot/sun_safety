// A function that converts a response body into Elevation :) .
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:sun_safety/elevation/elevation.dart';

Elevation _parseJson(String responseBody) {
  final parsedJson = jsonDecode(responseBody);

  return Elevation.fromJson(parsedJson);
}

class ElevationRepository {
  ElevationRepository({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  static const _baseUrl = 'api.opentopodata.org';
  final http.Client _httpClient;

  Future<Elevation> fetchData({
    required double latitude,
    required double longitude,
  }) async {
    final _uvResponse = await _httpClient.get(
      Uri.parse(
        'https://$_baseUrl/v1/srtm90m?locations=$latitude,$longitude',
      ),
    );

    if (_uvResponse.statusCode != 200) {
      debugPrint(_uvResponse.statusCode.toString() + " Failure");
    }

    debugPrint(_uvResponse.request.toString());
    // Use the compute function to run _parseJson in a separate isolate.
    return compute(_parseJson, _uvResponse.body);
  }
}
