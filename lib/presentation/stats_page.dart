import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sun_safety/models/uv_series.dart';
import 'package:sun_safety/uv/cubit/uv_cubit.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: NeumorphicTheme.baseColor(context),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SizedBox(
            height: constraints.maxHeight * 0.4,
            child: BlocConsumer<UvCubit, UVState>(
              buildWhen: (previous, current) {
                return previous.uvSeries != current.uvSeries;
              },
              listener: (context, state) {
                debugPrint("ayaya + ${state.uvSeries}");
              },
              builder: (context, state) {
                return SfCartesianChart(
                  margin: EdgeInsets.zero,
                  primaryXAxis: CategoryAxis(
                    //Hide the gridlines of x-axis
                    majorGridLines: const MajorGridLines(width: 0),
                    //Hide the axis line of x-axis
                    axisLine: const AxisLine(width: 0),
                    labelStyle: TextStyle(
                      color: _textColor(context),
                    ),
                    title: AxisTitle(
                      text: 'Hours',
                      textStyle: TextStyle(
                        color: _textColor(context),
                        fontSize: 16,
                      ),
                    ),
                  ),
                  primaryYAxis: CategoryAxis(
                    labelStyle: TextStyle(
                      color: _textColor(context),
                    ),
                    title: AxisTitle(
                      text: 'UV Index',
                      textStyle: TextStyle(
                        color: _textColor(context),
                        fontSize: 16,
                      ),
                    ),
                    //Hide the gridlines of y-axis
                    majorGridLines: const MajorGridLines(width: 0),
                    //Hide the axis line of y-axis
                    axisLine: const AxisLine(width: 0),
                  ),
                  series: <LineSeries<UVSeries, int>>[
                    LineSeries<UVSeries, int>(
                      dataSource: state.uvSeries,
                      xValueMapper: (UVSeries series, int hour) {
                        return series.hour;
                      },

                      yValueMapper: (UVSeries series, int hour) {
                        return num.parse(series.uvValue.toStringAsFixed(2));
                      },

                      // Enable data label
                      dataLabelSettings: DataLabelSettings(
                        isVisible: true,
                        textStyle: TextStyle(
                          color: _textColor(context),
                        ),
                      ),
                      color: _textColor(context),
                    ),
                  ],
                );
              },
            ),
          );
        },
      ),
    );
  }

  Color _textColor(BuildContext context) {
    if (NeumorphicTheme.isUsingDark(context)) {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }
}
