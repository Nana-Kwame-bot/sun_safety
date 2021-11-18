import 'package:direct_select_flutter/direct_select_container.dart';
import 'package:direct_select_flutter/direct_select_item.dart';
import 'package:direct_select_flutter/direct_select_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sun_safety/models/uv_series.dart';
import 'package:sun_safety/repository/uv_repository.dart';
import 'package:sun_safety/skin_type/cubit/skiin_type_cubit.dart';
import 'package:sun_safety/uv/cubit/uv_cubit.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatsPage extends StatelessWidget {
  const StatsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DirectSelectContainer(
      decoration: BoxDecoration(
        color: NeumorphicTheme.baseColor(context),
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SizedBox(
            height: constraints.maxHeight * 1,
            child: BlocBuilder<UvCubit, UVState>(
              buildWhen: (previous, current) {
                return previous.uvSeries != current.uvSeries;
              },
              builder: (context, state) {
                if (state.uvStatus == UVStatus.loading) {
                  return const CircularProgressIndicator();
                }
                if (state.uvStatus == UVStatus.failure) {
                  return const CircularProgressIndicator();
                }
                return Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      height: constraints.maxHeight * 0.275,
                      child: Column(
                        children: [
                          Align(
                            alignment: Alignment.center,
                            child: Column(
                              children: [
                                Text(
                                  "Minutes for sunlight exposure for sufficient Vitamin D intake",
                                  style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: _textColor(context),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const Text(
                                  "Based on skin type and current uv radiation",
                                  style: TextStyle(
                                    fontSize: 16.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          SizedBox(
                            height: constraints.maxHeight * 0.0125,
                          ),
                          SizedBox(
                            height: constraints.maxHeight * 0.0125,
                          ),
                          Text(
                            context.watch<UvCubit>().getVitaminD(),
                            style: TextStyle(
                              color: _textColor(context),
                              fontSize: 32.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 24.0),
                      height: constraints.maxHeight * 0.075,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Your Skin Type",
                          style: TextStyle(
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            color: _textColor(context),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: constraints.maxHeight * 0.025,
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24.0,
                      ),
                      child: Neumorphic(
                        style: const NeumorphicStyle(
                          shape: NeumorphicShape.concave,
                          depth: -10.0,
                        ),
                        child: BlocBuilder<SkiinTypeCubit, SkiinTypeState>(
                          builder: (context, state) {
                            return DirectSelectList(
                              onUserTappedListener: () {},
                              onItemSelectedListener: (dynamic item, int index,
                                  BuildContext context) {
                                BlocProvider.of<SkiinTypeCubit>(context,
                                        listen: false)
                                    .setBurnIndex(burnIndex: index);
                              },
                              defaultItemIndex: state.burnIndex,
                              focusedItemDecoration: const BoxDecoration(
                                border: BorderDirectional(
                                  bottom: BorderSide(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                  top: BorderSide(
                                    width: 1,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                              values: context.select<UVRepository, dynamic>(
                                  (UVRepository repository) {
                                return repository.generateTiles(
                                  color: _textColor(context),
                                );
                              }),
                              itemBuilder: (dynamic value) {
                                return DirectSelectItem(
                                  isSelected: true,
                                  itemHeight: constraints.maxHeight * 0.15,
                                  itemBuilder: (context, dynamic value) {
                                    return value as Widget;
                                  },
                                  value: value,
                                );
                              },
                            );
                          },
                        ),
                      ),
                    ),
                    SizedBox(
                      height: constraints.maxHeight * 0.05,
                    ),
                    SizedBox(
                      height: constraints.maxHeight * 0.4,
                      child: SfCartesianChart(
                        margin: const EdgeInsets.symmetric(horizontal: 8.0),
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
                              return num.parse(
                                  series.uvValue.toStringAsFixed(2));
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
                      ),
                    ),
                    SizedBox(
                      height: constraints.maxHeight * 0.025,
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
