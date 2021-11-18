import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
part 'skiin_type_state.dart';

class SkiinTypeCubit extends HydratedCubit<SkiinTypeState> {
  SkiinTypeCubit() : super(const SkiinTypeState(0));

  void setBurnIndex({required int burnIndex}) {
    emit(state.copyWith(burnIndex: burnIndex));
  }

  @override
  SkiinTypeState? fromJson(Map<String, dynamic> json) {
    final int burnIndex = json['burnIndex'] as int;
    return SkiinTypeState(burnIndex);
  }

  @override
  Map<String, dynamic>? toJson(SkiinTypeState state) {
    return {
      'burnIndex': state.burnIndex,
    };
  }
}
