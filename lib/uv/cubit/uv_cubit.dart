import 'dart:developer' as log;
import 'dart:math';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:intl/intl.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';
import 'package:sun_safety/cloud_coverage/cubit/cloud_coverage_cubit.dart';
import 'package:sun_safety/models/address.dart';
import 'package:sun_safety/models/result.dart';
import 'package:sun_safety/repository/goelocation.dart';
import 'package:sun_safety/uv/uv.dart';
import 'package:sun_safety/models/uv_series.dart';
import 'package:sun_safety/repository/uv_repository.dart';
import 'dart:async';
part 'uv_state.dart';

class UvCubit extends HydratedCubit<UVState> {
  late final StreamSubscription _elevationSubscription;
  final CloudCoverageCubit _coverageCubit;
  late final StreamSubscription _coverageSubscription;

  UvCubit(
    this._uvRepository,
    this._coverageCubit,
    this._locationRepository,
  ) : super(
          UVState(
            uv: UV(),
          ),
        ) {
    _coverageSubscription =
        _coverageCubit.stream.listen((CloudCoverageState cloudCoverageState) {
      _dropDown = cloudCoverageState.dropdownValue;
    });
  }

  final UVRepository _uvRepository;
  final UserLocationRepository _locationRepository;
  String? _dropDown;

  DateTime get now => _uvRepository.now;
  ItemScrollController itemScrollController = ItemScrollController();

  Future<void> fetchUV() async {
    emit(state.copyWith(uvStatus: UVStatus.loading));

    try {
      final UV _uv;
      final Position _position =
          await _locationRepository.getGeoLocationPosition();

      Address _currentAddress =
          await _locationRepository.getAddressFromLatLong(_position);

      if ((state.uv.result.isEmpty) ||
          (now.day != state.uv.result.first.uvTime.day)) {
        _uv = await _uvRepository.fetchData(
          latitude: _position.latitude,
          longitude: _position.longitude,
          elevation: _position.altitude,
        );
      } else {
        _uv = state.uv;
      }
      emit(
        state.copyWith(
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
          uvStatus: UVStatus.success,
          address: _currentAddress,
        ),
      );
      if (!(5 <= now.hour && now.hour <= 17)) {
        emit(
          state.copyWith(
            currentUV: 0.00,
          ),
        );
        debugPrint("is after 6"); //not sure
      }
    } on Exception catch (e) {
      log.log(e.toString());
      emit(state.copyWith(uvStatus: UVStatus.failure));
    }
  }

  double augmentRadiation({required double currentUV}) {
    switch (_dropDown) {
      case 'Clear skies':
        return currentUV;
      case 'Scattered clouds':
        return currentUV * 0.89;
      case 'Broken clouds':
        return currentUV * 0.73;
      case 'Overcast skies':
        return currentUV * 0.31;
      default:
        return currentUV;
    }
  }

  void updateUVfromTime({required int index}) {
    double _ultraViolet =
        augmentRadiation(currentUV: state.uvSeries[index].uvValue);

    Color _ultraColor = _uvRepository.getUVColor(indexLevel: _ultraViolet);
    String _ultraText = _uvRepository.getUVText(indexLevel: _ultraViolet);

    List<Color> _timeColors =
        List.generate(state.uv.result.length, (index) => Colors.white30);
    _timeColors[index] = _getTimeColor(index: index, ultraviolet: _ultraColor)!;

    emit(
      state.copyWith(
        currentUV: _ultraViolet,
        currentUVColor: _ultraColor,
        currentUVText: _ultraText,
        timeColor: _timeColors,
        // timeToBurn: setTimeToBurn(currentUV: _ultraViolet),
      ),
    );
  }

  void setIndex({required int selectedIndex}) {
    emit(state.copyWith(selectedIndex: selectedIndex));
  }

  List<Color> _getTimeColors({required List<Result> results}) {
    List<Color> _timeColors = [];
    for (int i = 0; i < results.length; i++) {
      _timeColors.add(Colors.white30);
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

      debugPrint("is after 6");
    }
    Color _ultraColor = _uvRepository.getUVColor(indexLevel: _ultraViolet);
    String _ultraText = _uvRepository.getUVText(indexLevel: _ultraViolet);
    final _twelveHourIndex =
        state.twelveHourDates.indexOf(DateFormat('j').format(now));

    List<Color> _timeColors =
        List.generate(state.uv.result.length, (index) => Colors.white30);

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
          selectedIndex: _twelveHourIndex,
          timeColor: _timeColors,
          // timeToBurn: setTimeToBurn(currentUV: _ultraViolet),
        ),
      );
    } else {
      emit(
        state.copyWith(
          currentUV: _ultraViolet,
          currentUVColor: _ultraColor,
          currentUVText: _ultraText,
          selectedIndex: null,
          timeColor: _timeColors,
          // timeToBurn: setTimeToBurn(currentUV: _ultraViolet),
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

    return augmentRadiation(currentUV: _uvValue);
  }

  @override
  UVState? fromJson(Map<String, dynamic> json) {
    try {
      final _uv = UV.fromJson(json);

      return UVState(
        uv: _uv,
      );
    } on Exception catch (e) {
      debugPrint(e.toString());
      return null;
    }
  }

  @override
  Map<String, dynamic>? toJson(UVState state) {
    try {
      return state.uv.toJson();
    } on Exception catch (e) {
      log.log(e.toString());
    }
  }

  //  return {
  //     'burnIndex': state.burnIndex,
  //   };

  @override
  Future<void> close() {
    _coverageSubscription.cancel();
    _elevationSubscription.cancel();
    return super.close();
  }
}
