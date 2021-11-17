part of 'cloud_coverage_cubit.dart';

enum CloudState { loading, loaded }

class CloudCoverageState extends Equatable {
  const CloudCoverageState(this.cloudCoverage, this.cloudState);

  final CloudCoverage cloudCoverage;
  final CloudState cloudState;

  @override
  List<Object> get props => [cloudCoverage, cloudState];

  @override
  bool get stringify => true;

  CloudCoverageState copyWith({
    CloudCoverage? cloudCoverage,
    CloudState? cloudState,
  }) {
    return CloudCoverageState(
      cloudCoverage ?? this.cloudCoverage,
      cloudState ?? this.cloudState,
    );
  }
}
