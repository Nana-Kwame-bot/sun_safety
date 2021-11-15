import 'dart:developer' as log;
import 'dart:math';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/intl.dart';
import 'package:sun_safety/models/address.dart';
import 'package:sun_safety/models/result.dart';
import 'package:sun_safety/models/uv.dart';
import 'package:sun_safety/models/uv_series.dart';
import 'package:sun_safety/repository/goelocation.dart';
import 'package:sun_safety/repository/uv_repository.dart';
part 'uv_state.dart';

class UvCubit extends HydratedCubit<UVState> {
  UvCubit(this._uvRepository, this._locationRepository)
      : super(
          UVState(
            uv: UV(),
            status: UVStatus.loading,
            address: const Address(),
          ),
        );

  final UVRepository _uvRepository;
  final UserLocationRepository _locationRepository;
  DateTime get now => _uvRepository.now;

  Future<void> fetchUV() async {
    final Position? _position =
        await _locationRepository.getGeoLocationPosition();

    if (_position == null) return;

    final _address = await _locationRepository.getAddressFromLatLong(_position);
    emit(
      state.copyWith(status: UVStatus.loading, address: _address),
    );

    final UV _uv;

    if (state.uv.result.last.uvTime.difference(now).inHours.abs() > 12) {
      _uv = await _uvRepository.fetchData(
        latitude: _position.latitude,
        longitude: _position.longitude,
      );
    } else {
      _uv = state.uv;
    }

    try {
      emit(
        state.copyWith(
          status: UVStatus.success,
          uv: _uv,
          integers: _getHours(results: _uv.result),
          currentUV: _getUV(results: _uv.result),
          currentUVColor: _uvRepository.getUVColor(
            indexLevel: _getUV(results: _uv.result),
          ),
          currentUVText: _uvRepository.getUVText(
            indexLevel: _getUV(results: _uv.result),
          ),
          uvSeries: _getSeries(results: _uv.result),
          twelveHourDates: _getTwelveHourDates(results: _uv.result),
        ),
      );
      if (now.hour > 18) {
        emit(state.copyWith(
          currentUV: 0.00,
          status: UVStatus.success,
        ));
        debugPrint("is after 6"); //not sure
      }
    } on Exception catch (e) {
      emit(
        state.copyWith(status: UVStatus.failure),
      );
      log.log(e.toString());
    }
  }

  void updateUVfromTime({required int index}) {
    double _ultraViolet = state.uvSeries[index].uvValue;
    Color _ultraColor = _uvRepository.getUVColor(indexLevel: _ultraViolet);
    String _ultraText = _uvRepository.getUVText(indexLevel: _ultraViolet);
    emit(
      state.copyWith(
        currentUV: _ultraViolet,
        currentUVColor: _ultraColor,
        currentUVText: _ultraText,
        status: UVStatus.success,
      ),
    );
  }

  void updateUVfromRefresh() {
    double _ultraViolet = _getUV(results: state.uv.result);
    if (now.hour > 18) {
      _ultraViolet = 0.0;

      debugPrint("is after 6"); //not sure
    }
    Color _ultraColor = _uvRepository.getUVColor(indexLevel: _ultraViolet);
    String _ultraText = _uvRepository.getUVText(indexLevel: _ultraViolet);

    emit(
      state.copyWith(
        currentUV: _ultraViolet,
        currentUVColor: _ultraColor,
        currentUVText: _ultraText,
        status: UVStatus.success,
      ),
    );
  }

  List<UVSeries> _getSeries({required List<Result> results}) {
    List<UVSeries> _uvSeries = [];
    final List<DateTime> _hours = [];
    final List<double> _ultraViolets = [];
    final List<int> _integers = [];
    for (int i = 0; i < results.length; i++) {
      if (!_hours.contains(results[i].uvTime)) {
        _hours.add(results[i].uvTime);
        _ultraViolets.add(results[i].uv!.toDouble());
      }
    }
    for (final time in _hours) {
      if (!_integers.contains(time.hour)) {
        _integers.add(time.hour);
      }
    }
    for (int i = 0; i < _integers.length; i++) {
      _uvSeries.add(
        UVSeries(
          hour: _integers[i],
          uvValue: _ultraViolets[i],
        ),
      );
    }

    return _uvSeries;
  }

  List<String> _getTwelveHourDates({required List<Result> results}) {
    final List<String> _hours = [];
    for (int i = 0; i < results.length; i++) {
      if (!_hours.contains(DateFormat('j').format(results[i].uvTime))) {
        _hours.add(DateFormat('j').format(results[i].uvTime));
      }
    }
    return _hours;
  }

  List<int> _getHours({required List<Result> results}) {
    final List<DateTime> _hours = [];
    final List<int> _integers = [];

    for (int i = 0; i < results.length; i++) {
      if (!_hours.contains(results[i].uvTime)) {
        _hours.add(results[i].uvTime);
      }
    }

    for (final time in _hours) {
      if (!_integers.contains(time.hour)) {
        _integers.add(time.hour);
      }
    }

    return _integers;
  }

  double _getUV({required List<Result> results}) {
    final double _uvValue;

    List<int> _differences = [];
    int _closestHour;
    for (int i = 0; i < results.length; i++) {
      _differences.add(now.difference(results[i].uvTime).inMinutes.abs());
    }

    _closestHour = _differences.indexOf(_differences.reduce(min));

    _uvValue = results[_closestHour].uv!.toDouble();

    return _uvValue;
  }

  @override
  UVState? fromJson(Map<String, dynamic> json) {
    try {
      final _uv = UV.fromJson(json);
      return UVState(
        uv: _uv,
        status: UVStatus.success,
      );
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
