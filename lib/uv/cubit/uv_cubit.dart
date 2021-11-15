import 'dart:developer' as log;
import 'dart:math';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

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

  Future<void> fetchUV() async {
    debugPrint("fetching");
    final Position? _position =
        await _locationRepository.getGeoLocationPosition();

    if (_position == null) return;
    debugPrint("position");
    final _address = await _locationRepository.getAddressFromLatLong(_position);
    emit(
      state.copyWith(status: UVStatus.loading, address: _address),
    );
    debugPrint("loading");
    final UV _uv;
    if (state.uv.result == []) {
      _uv = await _uvRepository.fetchData(
        latitude: _position.latitude,
        longitude: _position.longitude,
      );
    } else {
      _uv = state.uv;
    }
    try {
      debugPrint("latitude");
      emit(
        state.copyWith(
          status: UVStatus.success,
          uv: _uv,
          integers: _getHours(results: _uv.result),
          currentUV: _getUV(results: _uv.result),
          currentUVColor: _getUVColor(
            indexLevel: _getUV(results: _uv.result),
          ),
          currentUVText: _getUVText(
            indexLevel: _getUV(results: _uv.result),
          ),
          uvSeries: _getSeries(results: _uv.result),
        ),
      );

      debugPrint("done");
      log.log(state.toString());
    } on Exception catch (e) {
      emit(
        state.copyWith(status: UVStatus.failure),
      );
      log.log(e.toString());
    }
  }

  Future<void> refreshUV() async {
    if (state.status == UVStatus.success) return;
    final Position? _position =
        await _locationRepository.getGeoLocationPosition();
    if (_position == null) return;

    final _address = await _locationRepository.getAddressFromLatLong(_position);
    emit(
      state.copyWith(status: UVStatus.loading, address: _address),
    );
    final UV _uv;
    ///wrong way to do stuff, use difference between last date and today to see if you need to reload 12hours will do
    if (state.uv.result == []) {
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
          currentUVColor: _getUVColor(
            indexLevel: _getUV(results: _uv.result),
          ),
          currentUVText: _getUVText(
            indexLevel: _getUV(results: _uv.result),
          ),
          uvSeries: _getSeries(results: _uv.result),
        ),
      );

      log.log(state.toString());
    } on Exception catch (e) {
      emit(
        state.copyWith(status: UVStatus.failure),
      );
      log.log(e.toString());
    }
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
    log.log(_uvSeries.toString());
    return _uvSeries;
  }

  List<int> _getHours({required List<Result> results}) {
    final List<DateTime> _hours = [];
    final List<int> _integers = [];

    List<int> _firstHours = [];
    List<int> _secondHours = [];
    final List<double> _ultraViolets = [];

    final int _firstHalf;
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
    // for (int i = 0; i < _integers.length; i++) {
    //   _uvSeries.add(
    //     UVSeries(
    //       hour: _integers[i],
    //       uvValue: _ultraViolets[i],
    //     ),
    //   );
    // }

    // List<UVSeries> getSeries({}){}

    // log.log(_uvSeries.toString());

    _firstHalf = _integers.length ~/ 2;

    _firstHours = _integers.take(_firstHalf).toList();
    _secondHours = _integers.getRange(_firstHalf, _integers.length).toList();
    log.log(_firstHours.toString() + _secondHours.toString());

    // debugPrint(_hours.toString());
    debugPrint(_integers.toString());
    return _integers;
  }

  double _getUV({required List<Result> results}) {
    final double _uvValue;
    final DateTime _now = DateTime.now();

    List<int> _differences = [];
    int _closestHour;
    for (int i = 0; i < results.length; i++) {
      _differences.add(_now.difference(results[i].uvTime).inMinutes.abs());
    }

    _closestHour = _differences.indexOf(_differences.reduce(min));

    _uvValue = results[_closestHour].uv!.toDouble();

    log.log(results.toString());
    return _uvValue;
  }

  String _getUVText({required double indexLevel}) {
    if (0 <= indexLevel && indexLevel <= 3) {
      return "Low";
    } else if (3 <= indexLevel && indexLevel <= 6) {
      return "Moderate";
    } else if (6 <= indexLevel && indexLevel <= 8) {
      return "High";
    } else if (8 <= indexLevel && indexLevel <= 11) {
      return "Very High";
    } else if (indexLevel > 11) {
      return "Extreme";
    }
    return "Not Available";
  }

  Color _getUVColor({required double indexLevel}) {
    if (0 <= indexLevel && indexLevel <= 3) {
      return const Color(0xFF558B2F);
    } else if (3 <= indexLevel && indexLevel <= 6) {
      return const Color(0xFFF9A825);
    } else if (6 <= indexLevel && indexLevel <= 8) {
      return const Color(0xFFEF6C00);
    } else if (8 <= indexLevel && indexLevel <= 11) {
      return const Color(0xFFB71C1C);
    } else if (indexLevel > 11) {
      return const Color(0xFF6A1B9A);
    }
    return const Color(0xFFFFFFFF);
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
