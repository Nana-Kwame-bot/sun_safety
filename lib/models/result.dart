import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Result extends Equatable {
  // ignore: prefer_const_constructors_in_immutables
  Result({
    required this.uv,
    required this.uvTime,
  });
  late final int? uv;
  late final DateTime uvTime;

  Result.fromJson(Map<String, dynamic> json) {
    uv = json['uv'];
    uvTime = _parseDateTime(utcTime: json['uv_time']);
  }

  Result copyWith({
    int? uv,
    DateTime? uvTime,
  }) {
    return Result(
      uv: uv ?? this.uv,
      uvTime: uvTime ?? this.uvTime,
    );
  }

  DateTime _parseDateTime({required utcTime}) {
    String newString =
        utcTime.substring(0, 10) + ' ' + utcTime.substring(11, 23);
    debugPrint(newString);
    DateTime newDateTime = DateTime.parse(newString);
    debugPrint(DateFormat("EEE, d MMM yyyy HH:mm:ss").format(newDateTime));
    return newDateTime;
  }

  @override
  List<Object?> get props => [uv, uvTime];

  @override
  bool get stringify => true;
}
