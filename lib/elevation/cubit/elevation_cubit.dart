import 'dart:developer';
import 'package:equatable/equatable.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:sun_safety/elevation/elevation.dart';
import 'package:sun_safety/repository/elevation_repository.dart';
import 'package:sun_safety/repository/goelocation.dart';
part 'elevation_state.dart';

class ElevationCubit extends HydratedCubit<ElevationState> {
  ElevationCubit(this._elevationRepository, this._locationRepository)
      : super(ElevationState(Elevation()));

  final ElevationRepository _elevationRepository;
  final UserLocationRepository _locationRepository;

  Future<void> fetchElevationData() async {
    final Position? _position =
        await _locationRepository.getGeoLocationPosition();
    final Elevation _elevationData;

    try {
      // if (state.elevation.results.isEmpty) {
      //   log("caled");
      //   _elevationData = await _elevationRepository.fetchData(
      //       latitude: _position!.latitude, longitude: _position.longitude);
      // } else {
      //   _elevationData = state.elevation;
      // }
        _elevationData = state.elevation;
      emit(state.copyWith(elevation: _elevationData));
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  @override
  ElevationState? fromJson(Map<String, dynamic> json) {
    try {
      final elevation = Elevation.fromJson(json);
      return ElevationState(elevation);
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  @override
  Map<String, dynamic>? toJson(ElevationState state) {
    state.elevation.toJson();
  }
}
