import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
part 'cloud_coverage_state.dart';

class CloudCoverageCubit extends HydratedCubit<CloudCoverageState> {
  CloudCoverageCubit() : super(const CloudCoverageState());

  void changeDropDown({required String dropDownValue}) {
    emit(state.copyWith(dropdownValue: dropDownValue));
  }

  @override
  CloudCoverageState? fromJson(Map<String, dynamic> json) {
    return CloudCoverageState(
      dropdownValue: json['cloudState'],
    );
  }

  @override
  Map<String, dynamic>? toJson(CloudCoverageState state) {
    return {
      'cloudState': state.dropdownValue,
    };
  }
}
