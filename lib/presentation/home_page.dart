import 'dart:developer' as log;
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sun_safety/models/result.dart';
import 'package:sun_safety/models/uv_series.dart';
import 'package:sun_safety/uv/cubit/uv_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<bool> _isSelected = [
    false,
    false,
    false,
    false,
    false,
    false,
  ];

  // late final List<double> _ultraViolets = [];

  // List<int> _firstHours = [];
  // List<int> _secondHours = [];
  // List<UVSeries> _uvSeries = [];
  // Color _currentUVColor = Colors.white;
  // String _currentUVText = "";
  // late List<int> _integers = [];
  // double _currentUV = 0.0;
  // UVSeries _series;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: NeumorphicTheme.baseColor(context),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.only(left: 32.0),
                  height: constraints.maxHeight * 0.1,
                  child: BlocBuilder<UvCubit, UVState>(
                    buildWhen: (previous, current) {
                      return previous.address != current.address;
                    },
                    builder: (context, state) {
                      return Text(
                        state.address.country + ", " + state.address.locality,
                        style: const TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey,
                        ),
                      );
                    },
                  ),
                ),
              ),
              Center(
                child: BlocBuilder<UvCubit, UVState>(
                  builder: (BuildContext context, UVState state) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Neumorphic(
                            style: NeumorphicStyle(
                              shape: NeumorphicShape.convex,
                              lightSource: LightSource.bottomRight,
                              boxShape: NeumorphicBoxShape.roundRect(
                                BorderRadius.circular(12),
                              ),
                              depth: -10,
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 24.0,
                              ),
                              alignment: Alignment.center,
                              height: constraints.maxHeight * 0.1,
                              width: constraints.maxWidth * 0.6,
                              child: Text(
                                state.currentUVText,
                                style: TextStyle(
                                  fontSize: 24.0,
                                  fontWeight: FontWeight.bold,
                                  color: _textColor(context),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                              right: 24.0,
                            ),
                            height: constraints.maxHeight * 0.8,
                            width: constraints.maxWidth * 0.7,
                            child: Neumorphic(
                              style: NeumorphicStyle(
                                shape: NeumorphicShape.concave,
                                boxShape: const NeumorphicBoxShape.circle(),
                                depth: 10,
                                lightSource:
                                    NeumorphicTheme.isUsingDark(context)
                                        ? LightSource.topLeft
                                        : LightSource.bottomRight,
                                shadowLightColor: state.currentUVColor,
                                shadowLightColorEmboss: state.currentUVColor,
                                color: NeumorphicTheme.baseColor(context),
                              ),
                              child: Center(
                                child: Text(
                                  state.currentUV.toStringAsFixed(2),
                                  style: TextStyle(
                                    fontSize: 60.0,
                                    color: state.currentUVColor,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // List<int> _getHours({required List<Result> results}) {
  //   List<DateTime> _hours = [];
  //   final int _firstHalf;
  //   for (int i = 0; i < results.length; i++) {
  //     if (!_hours.contains(results[i].uvTime)) {
  //       _hours.add(results[i].uvTime);
  //       _ultraViolets.add(results[i].uv!.toDouble());
  //     }
  //   }

  //   for (final time in _hours) {
  //     if (!_integers.contains(time.hour)) {
  //       _integers.add(time.hour);
  //     }
  //   }
  //   for (int i = 0; i < _integers.length; i++) {
  //     _uvSeries.add(
  //       UVSeries(
  //         hour: _integers[i],
  //         uvValue: _ultraViolets[i],
  //       ),
  //     );
  //   }

  //   // _series = _series.copyWith();

  //   setState(() {});

  //   log.log(_uvSeries.toString());

  //   _firstHalf = _integers.length ~/ 2;

  //   _firstHours = _integers.take(_firstHalf).toList();
  //   _secondHours = _integers.getRange(_firstHalf, _integers.length).toList();
  //   log.log(_firstHours.toString() + _secondHours.toString());

  //   debugPrint(_hours.toString());
  //   debugPrint(_integers.toString());
  //   return _integers;
  // }

  // double _getUV({required List<Result> results}) {
  //   final double _uvValue;
  //   final DateTime _now = DateTime.now();

  //   List<int> _differences = [];
  //   int _closestHour;
  //   for (int i = 0; i < results.length; i++) {
  //     _differences.add(_now.difference(results[i].uvTime).inMinutes.abs());
  //   }

  //   _closestHour = _differences.indexOf(_differences.reduce(min));

  //   _uvValue = results[_closestHour].uv!.toDouble();

  //   log.log(results.toString());
  //   return _uvValue;
  // }

  // String _getUVText({required double indexLevel}) {
  //   if (0 <= indexLevel && indexLevel <= 3) {
  //     return "Low";
  //   } else if (3 <= indexLevel && indexLevel <= 6) {
  //     return "Moderate";
  //   } else if (6 <= indexLevel && indexLevel <= 8) {
  //     return "High";
  //   } else if (8 <= indexLevel && indexLevel <= 11) {
  //     return "Very High";
  //   } else if (indexLevel > 11) {
  //     return "Extreme";
  //   }
  //   return "Not Available";
  // }

  // Color _getUVColor({required double indexLevel}) {
  //   if (0 <= indexLevel && indexLevel <= 3) {
  //     return const Color(0xFF558B2F);
  //   } else if (3 <= indexLevel && indexLevel <= 6) {
  //     return const Color(0xFFF9A825);
  //   } else if (6 <= indexLevel && indexLevel <= 8) {
  //     return const Color(0xFFEF6C00);
  //   } else if (8 <= indexLevel && indexLevel <= 11) {
  //     return const Color(0xFFB71C1C);
  //   } else if (indexLevel > 11) {
  //     return const Color(0xFF6A1B9A);
  //   }
  //   return const Color(0xFFFFFFFF);
  // }

  // Color? _iconsColor(BuildContext context) {
  //   final theme = NeumorphicTheme.of(context);
  //   if (theme!.isUsingDark) {
  //     return theme.current!.accentColor;
  //   } else {
  //     return null;
  //   }
  // }

  Color _textColor(BuildContext context) {
    if (NeumorphicTheme.isUsingDark(context)) {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }
}
