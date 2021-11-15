import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class UVObserver implements BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    // debugPrint(change.toString());
  }

  @override
  void onClose(BlocBase bloc) {
    debugPrint(bloc.toString());
  }

  @override
  void onCreate(BlocBase bloc) {
    debugPrint(bloc.toString());
  }

  @override
  void onError(BlocBase bloc, Object error, StackTrace stackTrace) {
    debugPrint(error.toString() + stackTrace.toString());
  }

  @override
  void onEvent(Bloc bloc, Object? event) {
    // debugPrint(event.toString());
  }

  @override
  void onTransition(Bloc bloc, Transition transition) {
    // debugPrint(transition.toString());
  }
}
