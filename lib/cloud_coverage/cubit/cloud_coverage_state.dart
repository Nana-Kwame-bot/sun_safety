part of 'cloud_coverage_cubit.dart';

class CloudCoverageState extends Equatable {
  const CloudCoverageState({
    this.dropdownValue = 'Clear Skies',
    this.items = const [
      'Clear Skies',
      'Scattered clouds',
      'Broken clouds',
      'Overcast skies',
    ],
  });

  final String dropdownValue;
  final List<String> items;

  @override
  List<Object> get props => [dropdownValue, items];

  @override
  bool get stringify => true;

  CloudCoverageState copyWith({
    String? dropdownValue,
    List<String>? items,
  }) {
    return CloudCoverageState(
      dropdownValue: dropdownValue ?? this.dropdownValue,
      items: items ?? this.items,
    );
  }
}
