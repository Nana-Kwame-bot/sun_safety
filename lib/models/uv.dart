import 'package:equatable/equatable.dart';

import 'package:sun_safety/models/result.dart';

class UV extends Equatable {
  // ignore: prefer_const_constructors_in_immutables
  UV({
    this.result = const <Result>[],
  });
  late final List<Result> result;

  UV.fromJson(Map<String, dynamic> json) {
    result = List.from(json['result']).map((e) => Result.fromJson(e)).toList();
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['result'] = result.map((e) => e.toJson()).toList();
    return _data;
  }

  @override
  List<Object> get props => [result];

  UV copyWith({
    List<Result>? result,
  }) {
    return UV(
      result: result ?? this.result,
    );
  }

  @override
  bool get stringify => true;
}
