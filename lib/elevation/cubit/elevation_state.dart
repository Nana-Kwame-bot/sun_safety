part of 'elevation_cubit.dart';

class ElevationState extends Equatable {
  const ElevationState(this.elevation);

  final Elevation elevation;

  @override
  List<Object> get props => [elevation];

  @override
  bool get stringify => true;

  ElevationState copyWith({
    Elevation? elevation,
  }) {
    return ElevationState(
      elevation ?? this.elevation,
    );
  }
}
