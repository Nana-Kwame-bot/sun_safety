import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'theme_state.dart';

class ThemeCubit extends HydratedCubit<ThemeState> {
  ThemeCubit() : super(const ThemeState(ThemeMode.system));
  // ThemeMode? themeMode;

  void onAppStarted() {
    if (state.props.isEmpty) {
      emit(state.copyWith(themeMode: ThemeMode.system));
    } else {
      emit(state);
    }
  }

  void changeTheme({required int index}) {
    switch (index) {
      case 0:
        emit(state.copyWith(themeMode: ThemeMode.system));
        break;
      case 1:
        emit(state.copyWith(themeMode: ThemeMode.light));
        break;
      case 2:
        emit(state.copyWith(themeMode: ThemeMode.dark));
        break;
      // default:
      //   emit(state.copyWith(themeMode: ThemeMode.system));
    }
  }

  @override
  ThemeState? fromJson(Map<String, dynamic> json) {
    final state = ThemeState.fromJson(json);
    return ThemeState(state.themeMode);
  }

  @override
  Map<String, dynamic>? toJson(ThemeState state) {
    return state.toJson();
  }
}
