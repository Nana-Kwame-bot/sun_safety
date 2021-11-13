import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:sun_safety/models/uv.dart';
import 'package:sun_safety/repository/goelocation.dart';
import 'package:sun_safety/repository/uv_repository.dart';
part 'uv_state.dart';

class UvCubit extends HydratedCubit<UVState> {
  UvCubit(this._uvRepository, this._locationRepository)
      : super(UVState(UV(result: const [])));

  final UVRepository _uvRepository;
  final UserLocationRepository _locationRepository;

  Future<void> fetchUV() async {
    debugPrint("fetching");
    final Position? _position =
        await _locationRepository.getGeoLocationPosition();

    if (_position == null) return;
    _locationRepository.getAddressFromLatLong(_position);
    emit(state.copyWith(status: UVStatus.loading));

    try {
      final _uv = await _uvRepository.fetchData(
        latitude: _position.latitude,
        longitude: _position.longitude,
      );

      emit(state.copyWith(status: UVStatus.success, uv: _uv));
    } on Exception catch (e) {
      emit(state.copyWith(status: UVStatus.failure));
      debugPrint(e.toString());
    }
  }

  Future<void> refreshUV() async {
    if (state.status == UVStatus.success) return;
    final Position? _position =
        await _locationRepository.getGeoLocationPosition();
    if (_position == null) return;

    emit(state.copyWith(status: UVStatus.loading));

    try {
      final _uv = await _uvRepository.fetchData(
        latitude: _position.latitude,
        longitude: _position.longitude,
      );
      emit(state.copyWith(status: UVStatus.success, uv: _uv));
    } on Exception catch (e) {
      emit(state.copyWith(status: UVStatus.failure));
      debugPrint(e.toString());
    }
  }

  @override
  UVState? fromJson(Map<String, dynamic> json) {
    try {
      final uv = UV.fromJson(json);
      return UVState(uv, status: UVStatus.success);
    } on Exception catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(UVState state) {
    if (state.status == UVStatus.success) {
      return state.uv.toJson();
    }
    return null;
  }
}
