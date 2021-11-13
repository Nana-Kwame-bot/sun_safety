import 'package:equatable/equatable.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'uv_state.dart';

class UvCubit extends HydratedCubit<UvState> {
  UvCubit() : super(UvInitial());

  @override
  UvState? fromJson(Map<String, dynamic> json) {
    // TODO: implement fromJson
    throw UnimplementedError();
  }

  @override
  Map<String, dynamic>? toJson(UvState state) {
    // TODO: implement toJson
    throw UnimplementedError();
  }
}
