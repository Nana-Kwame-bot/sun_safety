import 'dart:developer' as log;
import 'dart:math';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sun_safety/elevation/cubit/elevation_cubit.dart';
import 'package:sun_safety/address/address.dart';
import 'package:sun_safety/elevation/elevation.dart';
import 'package:sun_safety/models/result.dart';
import 'package:sun_safety/uv/uv.dart';
import 'package:sun_safety/models/uv_series.dart';
import 'package:sun_safety/repository/goelocation.dart';
import 'package:sun_safety/repository/uv_repository.dart';
import 'dart:async';
part 'uv_state.dart';

class UvCubit extends HydratedCubit<UVState> {
  final ElevationCubit _elevationCubit;
  late final StreamSubscription _elevationSubscription;

  UvCubit(
    this._uvRepository,
    this._locationRepository,
    this._elevationCubit,
  ) : super(
          UVState(
            uv: UV(),
            status: UVStatus.loading,
          ),
        ) {
    _elevationSubscription =
        _elevationCubit.stream.listen((ElevationState elevationState) {
      _elevation = elevationState.elevation;
    });
  }

  final UVRepository _uvRepository;
  late Elevation _elevation;
  final UserLocationRepository _locationRepository;

  DateTime get now => _uvRepository.now;
  ItemScrollController itemScrollController = ItemScrollController();

  Future<void> fetchUV() async {
    final Position? _position =
        await _locationRepository.getGeoLocationPosition();

    final UV _uv;

    // 5 <= now.hour && now.hour <= 17

    if ((now.day != state.uv.result.first.uvTime.day) ||
        state.uv.result.isEmpty) {
      _uv = await _uvRepository.fetchData(
        latitude: _position!.latitude,
        longitude: _position.longitude,
        elevation: _elevation.results.first.elevation,
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
          timeColor: _getTimeColors(results: _uv.result),
        ),
      );
      if (!(5 <= now.hour && now.hour <= 17)) {
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

    List<Color> _timeColors =
        List.generate(state.uv.result.length, (index) => Colors.white);
    _timeColors[index] = _getTimeColor(index: index, ultraviolet: _ultraColor)!;

    emit(
      state.copyWith(
        currentUV: _ultraViolet,
        currentUVColor: _ultraColor,
        currentUVText: _ultraText,
        status: UVStatus.success,
        timeColor: _timeColors,
      ),
    );
  }

  void setIndex({required int selectedIndex}) {
    emit(state.copyWith(selectedIndex: selectedIndex));
  }

  List<Color> _getTimeColors({required List<Result> results}) {
    List<Color> _timeColors = [];
    for (int i = 0; i < results.length; i++) {
      _timeColors.add(Colors.white);
    }
    return _timeColors;
  }

  Color? _getTimeColor({required int index, required Color ultraviolet}) {
    if (state.selectedIndex == index) {
      return ultraviolet.withOpacity(0.5);
    } else {
      return null;
    }
  }

  void updateUVfromRefresh() {
    double _ultraViolet = _getUV(results: state.uv.result);
    if (!(5 <= now.hour && now.hour <= 17)) {
      _ultraViolet = 0.0;

      debugPrint("is after 6"); //not sure
    }
    Color _ultraColor = _uvRepository.getUVColor(indexLevel: _ultraViolet);
    String _ultraText = _uvRepository.getUVText(indexLevel: _ultraViolet);
    final _twelveHourIndex =
        state.twelveHourDates.indexOf(DateFormat('j').format(now));

    List<Color> _timeColors =
        List.generate(state.uv.result.length, (index) => Colors.white);

    if (!(_twelveHourIndex == -1)) {
      _timeColors[_twelveHourIndex] = _ultraColor.withOpacity(0.5);
      itemScrollController.scrollTo(
        index: _twelveHourIndex,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInCubic,
      );
      emit(
        state.copyWith(
          currentUV: _ultraViolet,
          currentUVColor: _ultraColor,
          currentUVText: _ultraText,
          status: UVStatus.success,
          selectedIndex: _twelveHourIndex,
          timeColor: _timeColors,
        ),
      );
    } else {
      emit(
        state.copyWith(
          currentUV: _ultraViolet,
          currentUVColor: _ultraColor,
          currentUVText: _ultraText,
          status: UVStatus.success,
          selectedIndex: null,
          timeColor: _timeColors,
        ),
      );
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

  @override
  Future<void> close() {
    _elevationSubscription.cancel();
    return super.close();
  }
}
