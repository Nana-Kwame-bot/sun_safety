import 'dart:developer' as log;
import 'dart:math';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sun_safety/models/address.dart';
import 'package:sun_safety/models/elevation.dart';
import 'package:sun_safety/models/result.dart';
import 'package:sun_safety/models/uv.dart';
import 'package:sun_safety/models/uv_series.dart';
import 'package:sun_safety/repository/elevation_repository.dart';
import 'package:sun_safety/repository/goelocation.dart';
import 'package:sun_safety/repository/uv_repository.dart';
part 'uv_state.dart';

class UvCubit extends HydratedCubit<UVState> {
  UvCubit(
      this._uvRepository, this._locationRepository, this._elevationRepository)
      : super(
          UVState(
            uv: UV(),
            status: UVStatus.loading,
            address: const Address(),
          ),
        );

  final UVRepository _uvRepository;
  final UserLocationRepository _locationRepository;
  final ElevationRepository _elevationRepository;
  DateTime get now => _uvRepository.now;
  ItemScrollController get itemScrollController => ItemScrollController();

  Future<void> fetchUV() async {
    final Position? _position =
        await _locationRepository.getGeoLocationPosition();

    final _address =
        await _locationRepository.getAddressFromLatLong(_position!);

    final Elevation _elevation = await _elevationRepository.fetchData(
      latitude: _position.latitude,
      longitude: _position.longitude,
    );

    emit(
      state.copyWith(status: UVStatus.loading, address: _address),
    );

    final UV _uv;

    if (!_isBetweenDates(

        ///remove ! when done debugging
        firstDate: state.uv.result.first.uvTime,
        lastDate: state.uv.result.last.uvTime)) {
      _uv = await _uvRepository.fetchData(
        latitude: _position.latitude,
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
      if (!_isBetweenDates(
          firstDate: state.uv.result.first.uvTime,
          lastDate: state.uv.result.last.uvTime)) {
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

  bool _isBetweenDates(
      {required DateTime firstDate, required DateTime lastDate}) {
    debugPrint(
        "firstDate" + firstDate.toString() + " lastDate" + lastDate.toString());
    if (firstDate.isBefore(now) && lastDate.isAfter(now)) {
      debugPrint("is between");
      return true;
    }
    return false;
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
    if (!_isBetweenDates(
        firstDate: state.uv.result.first.uvTime,
        lastDate: state.uv.result.last.uvTime)) {
      _ultraViolet = 0.0;

      debugPrint("is after 6"); //not sure
    }
    Color _ultraColor = _uvRepository.getUVColor(indexLevel: _ultraViolet);
    String _ultraText = _uvRepository.getUVText(indexLevel: _ultraViolet);
    final _twelveHourIndex =
        state.twelveHourDates.indexOf(DateFormat('j').format(now));
    if (!(_twelveHourIndex == -1)) {
      // List<Color> _timeColors =
      //     List.generate(state.uv.result.length, (index) => Colors.white);
      // _timeColors[_twelveHourIndex] = state.currentUVColor.withOpacity(0.5);
      // setIndex(selectedIndex: _twelveHourIndex);
      itemScrollController.scrollTo(
        index: _twelveHourIndex,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeInCubic,
      );
      log.log(_twelveHourIndex.toString());

      emit(
        state.copyWith(
          currentUV: _ultraViolet,
          currentUVColor: _ultraColor,
          currentUVText: _ultraText,
          status: UVStatus.success,
          selectedIndex: _twelveHourIndex,
        ),
      );
      log.log(state.selectedIndex.toString() + "Hellooooooooo");
    } else {
      emit(
        state.copyWith(
          currentUV: _ultraViolet,
          currentUVColor: _ultraColor,
          currentUVText: _ultraText,
          status: UVStatus.success,
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
}
