import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import '../models/uv.dart';
import 'package:http/http.dart' as http;

// A function that converts a response body into Ultraviolet radiation :) .
UV _parseJson(String responseBody) {
  final parsedJson = jsonDecode(responseBody);

  return UV.fromJson(parsedJson);
}

/// Exception thrown when uvSearch fails.
// class UVIRequestFailure implements Exception {}

class UVRepository {
  UVRepository({http.Client? httpClient})
      : _httpClient = httpClient ?? http.Client();

  static const _baseUrl = 'api.openuv.io';
  static const apiKey = 'd686115e6106e4047df314f497807b7c';
  final http.Client _httpClient;
  late DateTime _now;

  DateTime get now => _now;

  void getNow() {
    _now = DateTime.now();
    debugPrint("Now + $_now");
  }

  Future<UV> fetchData({
    required double latitude,
    required double longitude,
    required num? elevation,
  }) async {
    dynamic _uvRequest;
    if (elevation == null) {
      _uvRequest = Uri.https(
        _baseUrl,
        '/api/v1/forecast',
        <String, String>{
          'lat': latitude.toString(),
          'lng': longitude.toString(),
          'dt': _now.toIso8601String(),
        },
      );
    } else {
      _uvRequest = Uri.https(
        _baseUrl,
        '/api/v1/forecast',
        <String, String>{
          'lat': latitude.toString(),
          'lng': longitude.toString(),
          'dt': _now.toIso8601String(),
          'alt': elevation.toString(),
        },
      );
    }

    final _uvResponse = await _httpClient.get(
      _uvRequest,
      headers: {
        'x-access-token': apiKey,
      },
    );

    if (_uvResponse.statusCode != 200) {
      debugPrint(_uvResponse.statusCode.toString() + " Failure");
    }

    debugPrint(_uvResponse.request.toString());
    // Use the compute function to run _parseJson in a separate isolate.
    return compute(_parseJson, _uvResponse.body);
  }

  String getUVText({required double indexLevel}) {
    if (0 <= indexLevel && indexLevel <= 3) {
      return "Low";
    } else if (3 <= indexLevel && indexLevel <= 6) {
      return "Moderate";
    } else if (6 <= indexLevel && indexLevel <= 8) {
      return "High";
    } else if (8 <= indexLevel && indexLevel <= 11) {
      return "Very High";
    } else if (indexLevel > 11) {
      return "Extreme";
    }
    return "Not Available";
  }

  Color getUVColor({required double indexLevel}) {
    if (0 <= indexLevel && indexLevel <= 3) {
      return const Color(0xFF558B2F);
    } else if (3 <= indexLevel && indexLevel <= 6) {
      return const Color(0xFFF9A825);
    } else if (6 <= indexLevel && indexLevel <= 8) {
      return const Color(0xFFEF6C00);
    } else if (8 <= indexLevel && indexLevel <= 11) {
      return const Color(0xFFB71C1C);
    } else if (indexLevel > 11) {
      return const Color(0xFF6A1B9A);
    }
    return const Color(0xFFFFFFFF);
  }
}
