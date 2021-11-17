import 'dart:developer';

import 'package:equatable/equatable.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'theme_state.dart';

class ThemeCubit extends HydratedCubit<ThemeState> {
  ThemeCubit() : super(const ThemeState(ThemeMode.system));

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
      default:
        emit(state.copyWith(themeMode: ThemeMode.system));
    }
  }

  @override
  ThemeState? fromJson(Map<String, dynamic> json) {
    try {
      return json['theme'];
    } on Exception catch (e) {
      log(e.toString());
    }
  }

  @override
  Map<String, dynamic>? toJson(ThemeState state) {
    final _themeString = state.toString();
    return {
      'theme': state,
    };
  }
}
