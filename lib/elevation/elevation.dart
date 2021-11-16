import 'package:equatable/equatable.dart';

import 'package:sun_safety/models/results.dart';

class Elevation extends Equatable {
  // ignore: prefer_const_constructors_in_immutables
  Elevation({
    this.results = const [],
    this.status = "",
  });
  late final List<Results> results;
  late final String status;

  Elevation.fromJson(Map<String, dynamic> json) {
    results =
        List.from(json['results']).map((e) => Results.fromJson(e)).toList();
    status = json['status'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['results'] = results.map((e) => e.toJson()).toList();
    _data['status'] = status;
    return _data;
  }

  @override
  List<Object> get props => [results, status];

  Elevation copyWith({
    List<Results>? results,
    String? status,
  }) {
    return Elevation(
      results: results ?? this.results,
      status: status ?? this.status,
    );
  }

  @override
  bool get stringify => true;
}
