import 'package:equatable/equatable.dart';

class UVSeries extends Equatable {
  final int hour;
  final double uvValue;

  const UVSeries({required this.hour, required this.uvValue});

  @override
  List<Object> get props => [hour, uvValue];

  UVSeries copyWith({
    int? hour,
    double? uvValue,
  }) {
    return UVSeries(
      hour: hour ?? this.hour,
      uvValue: uvValue ?? this.uvValue,
    );
  }

  @override
  bool get stringify => true;
}
