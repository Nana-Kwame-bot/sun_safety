import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:sun_safety/cloud_coverage/cloud_coverage.dart';
import 'package:sun_safety/repository/cloud_coverage_repository.dart';
part 'cloud_coverage_state.dart';

class CloudCoverageCubit extends HydratedCubit<CloudCoverageState> {
  CloudCoverageCubit(this._cloudCoverageRepository)
      : super(const CloudCoverageState(
          CloudCoverage("", []),
          CloudState.loading,
        ));

  final CloudCoverageRepository _cloudCoverageRepository;

  void getData() {
    final CloudCoverage _cloudData;
    emit(
      state.copyWith(cloudState: CloudState.loading),
    );
    if (state.cloudCoverage.dropdownValue.isEmpty ||
        state.cloudCoverage.items.isEmpty) {
      _cloudData = _cloudCoverageRepository.getCloudData();
      emit(
        state.copyWith(
            cloudCoverage: _cloudData, cloudState: CloudState.loaded),
      );
    } else {
      {
        _cloudData = state.cloudCoverage;
        emit(
          state.copyWith(
              cloudCoverage: _cloudData, cloudState: CloudState.loaded),
        );
      }
    }
  }

  void changeDropDown({required String dropDownValue}) {
    final CloudCoverage _cloudData = _cloudCoverageRepository.getCloudData();
    emit(
      state.copyWith(
          cloudCoverage: _cloudData.copyWith(dropdownValue: dropDownValue),
          cloudState: CloudState.loaded),
    );
  }

  @override
  CloudCoverageState? fromJson(Map<String, dynamic> json) {
    try {
      final _cloudCoverage = CloudCoverage.fromMap(json);
      return CloudCoverageState(_cloudCoverage, CloudState.loaded);
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  @override
  Map<String, dynamic>? toJson(CloudCoverageState state) {
    state.cloudCoverage.toJson();
  }
}
