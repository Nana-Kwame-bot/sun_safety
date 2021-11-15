part of 'uv_cubit.dart';

enum UVStatus { loading, success, failure }

class UVState extends Equatable {
  const UVState({
    this.address = const Address(),
    required this.uv,
    required this.status,
    this.currentUVColor = Colors.white,
    this.currentUVText = "",
    this.integers = const [],
    this.currentUV = 0.0,
    this.uvSeries = const [],
    this.twelveHourDates = const [],
  });

  final UV uv;
  final UVStatus status;
  final Address address;
  final Color currentUVColor;
  final String currentUVText;
  final List<int> integers;
  final double currentUV;
  final List<UVSeries> uvSeries;
  final List<String> twelveHourDates;

  @override
  List<Object> get props {
    return [
      uv,
      status,
      address,
      currentUVColor,
      currentUVText,
      integers,
      currentUV,
      uvSeries,
      twelveHourDates,
    ];
  }

  @override
  bool get stringify => true;

  UVState copyWith({
    UV? uv,
    UVStatus? status,
    Address? address,
    Color? currentUVColor,
    String? currentUVText,
    List<int>? integers,
    double? currentUV,
    List<UVSeries>? uvSeries,
    List<String>? twelveHourDates,
  }) {
    return UVState(
      uv: uv ?? this.uv,
      status: status ?? this.status,
      address: address ?? this.address,
      currentUVColor: currentUVColor ?? this.currentUVColor,
      currentUVText: currentUVText ?? this.currentUVText,
      integers: integers ?? this.integers,
      currentUV: currentUV ?? this.currentUV,
      uvSeries: uvSeries ?? this.uvSeries,
      twelveHourDates: twelveHourDates ?? this.twelveHourDates,
    );
  }
}
