part of 'uv_cubit.dart';

enum UVStatus { loading, success, failure }

class UVState extends Equatable {
  const UVState({
    required this.uv,
    this.currentUVColor = Colors.white,
    this.currentUVText = "",
    this.integers = const [],
    this.currentUV = 0.0,
    this.uvSeries = const [],
    this.twelveHourDates = const [],
    this.timeColor = const [],
    this.selectedIndex = 0,
    this.uvStatus = UVStatus.loading,
    this.timeToBurn = 0.0,
  });

  final UV uv;
  final Color currentUVColor;
  final String currentUVText;
  final List<int> integers;
  final double currentUV;
  final List<UVSeries> uvSeries;
  final List<String> twelveHourDates;
  final List<Color> timeColor;
  final int selectedIndex;
  final UVStatus uvStatus;
  final double timeToBurn;

  @override
  List<Object> get props {
    return [
      uv,
      currentUVColor,
      currentUVText,
      integers,
      currentUV,
      uvSeries,
      twelveHourDates,
      timeColor,
      selectedIndex,
      uvStatus,
      timeToBurn,
    ];
  }

  @override
  bool get stringify => true;

  UVState copyWith({
    UV? uv,
    Color? currentUVColor,
    String? currentUVText,
    List<int>? integers,
    double? currentUV,
    List<UVSeries>? uvSeries,
    List<String>? twelveHourDates,
    List<Color>? timeColor,
    int? selectedIndex,
    UVStatus? uvStatus,
    double? timeToBurn,
  }) {
    return UVState(
      uv: uv ?? this.uv,
      currentUVColor: currentUVColor ?? this.currentUVColor,
      currentUVText: currentUVText ?? this.currentUVText,
      integers: integers ?? this.integers,
      currentUV: currentUV ?? this.currentUV,
      uvSeries: uvSeries ?? this.uvSeries,
      twelveHourDates: twelveHourDates ?? this.twelveHourDates,
      timeColor: timeColor ?? this.timeColor,
      selectedIndex: selectedIndex ?? this.selectedIndex,
      uvStatus: uvStatus ?? this.uvStatus,
      timeToBurn: timeToBurn ?? this.timeToBurn,
    );
  }
}
