import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:sun_safety/cloud_coverage/cubit/cloud_coverage_cubit.dart';
import 'package:sun_safety/repository/uv_repository.dart';
import 'package:sun_safety/skin_type/cubit/skiin_type_cubit.dart';
import 'package:sun_safety/uv/cubit/uv_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  CrossFadeState _crossFadeState = CrossFadeState.showFirst;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: NeumorphicTheme.baseColor(context),
      ),
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
                      if (state.uvStatus == UVStatus.loading) {
                        return const SizedBox();
                      }
                      if (state.uvStatus == UVStatus.failure) {
                        return const SizedBox();
                      }
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
                    if (state.uvStatus == UVStatus.loading) {
                      return SpinKitFadingCircle(
                        color: _textColor(context),
                        size: constraints.maxHeight * 0.1,
                      );
                    } else if (state.uvStatus == UVStatus.failure) {
                      return const Dialog(
                        child: Text("Failed to load data"),
                      );
                    } else {
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24.0,
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: constraints.maxHeight * 0.1375,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text(
                                    "Cloud Coverage",
                                    style: TextStyle(
                                      color: _textColor(context),
                                      fontSize: 18.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  BlocBuilder<CloudCoverageCubit,
                                      CloudCoverageState>(
                                    buildWhen: (previous, current) {
                                      return previous.dropdownValue !=
                                          current.dropdownValue;
                                    },
                                    builder: (context, state) {
                                      return DropdownButton<String>(
                                        enableFeedback: true,
                                        value: state.dropdownValue,
                                        dropdownColor:
                                            NeumorphicTheme.baseColor(context),
                                        icon: const Icon(Icons.arrow_downward),
                                        iconSize: 24,
                                        elevation: 16,
                                        style: const TextStyle(
                                          color: Colors.grey,
                                        ),
                                        underline: Container(
                                          height: 2,
                                          color: Colors.grey,
                                        ),
                                        onChanged: (String? newValue) {
                                          BlocProvider.of<CloudCoverageCubit>(
                                                  context)
                                              .changeDropDown(
                                            dropDownValue: newValue!,
                                          );
                                        },
                                        items: state.items
                                            .map<DropdownMenuItem<String>>(
                                                (String value) {
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value,
                                              style: TextStyle(
                                                color: _textColor(context),
                                                fontSize: 16.0,
                                              ),
                                            ),
                                          );
                                        }).toList(),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: constraints.maxHeight * 0.5,
                              width: constraints.maxWidth * 0.7,
                              child: GestureDetector(
                                onTap: () async {
                                  setState(() {
                                    _crossFadeState = CrossFadeState.showSecond;
                                  });
                                  await Future.delayed(
                                      const Duration(milliseconds: 1000), () {
                                    setState(() {
                                      _crossFadeState =
                                          CrossFadeState.showFirst;
                                    });
                                  });
                                  RepositoryProvider.of<UVRepository>(context,
                                          listen: false)
                                      .getNow();
                                  BlocProvider.of<UvCubit>(context,
                                          listen: false)
                                      .updateUVfromRefresh();
                                },
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
                                    shadowLightColorEmboss:
                                        state.currentUVColor,
                                    color: NeumorphicTheme.baseColor(context),
                                  ),
                                  child: Center(
                                    child: AnimatedCrossFade(
                                      crossFadeState: _crossFadeState,
                                      duration:
                                          const Duration(milliseconds: 500),
                                      reverseDuration:
                                          const Duration(milliseconds: 0),
                                      secondChild: Text(
                                        "At the moment",
                                        style: TextStyle(
                                          fontSize: 26.0,
                                          color: _textColor(context),
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                      firstChild: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          AnimatedSwitcher(
                                            duration: const Duration(
                                                milliseconds: 250),
                                            child: Text(
                                              state.currentUV
                                                  .toStringAsFixed(2),
                                              key: ValueKey(state.currentUV),
                                              style: TextStyle(
                                                fontSize: 60.0,
                                                color: state.currentUVColor,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ),
                                          SizedBox(
                                            height:
                                                constraints.maxHeight * 0.025,
                                          ),
                                          Text(
                                            state.currentUVText,
                                            key: ValueKey(state.currentUVText),
                                            style: TextStyle(
                                              fontSize: 16.0,
                                              fontWeight: FontWeight.bold,
                                              color: _textColor(context),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Neumorphic(
                              style: const NeumorphicStyle(
                                shape: NeumorphicShape.concave,
                                depth: -20.0,
                              ),
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16.0,
                                ),
                                height: constraints.maxHeight * 0.1,
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    Text(
                                      "Safe Exposure Time :",
                                      style: TextStyle(
                                        color: _textColor(context),
                                        fontSize: 20.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    Text(
                                      getTimeString(
                                        context
                                            .watch<SkinTypeCubit>()
                                            .getTimeToBurn(
                                                currentUV: state.currentUV)
                                            .round(),
                                      ),
                                      // .toString() +
                                      //     " mins",
                                      style: TextStyle(
                                        color: _textColor(context),
                                        fontSize: 18.0,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SizedBox(
                              height: constraints.maxHeight * 0.0375,
                            ),
                            SizedBox(
                              height: constraints.maxHeight * 0.125,
                              width: constraints.maxWidth,
                              child: ScrollablePositionedList.builder(
                                physics: const BouncingScrollPhysics(),
                                itemScrollController:
                                    BlocProvider.of<UvCubit>(context)
                                        .itemScrollController,
                                scrollDirection: Axis.horizontal,
                                itemBuilder: (context, index) {
                                  return GestureDetector(
                                    onTap: () {
                                      BlocProvider.of<UvCubit>(context,
                                              listen: false)
                                          .setIndex(selectedIndex: index);
                                      BlocProvider.of<UvCubit>(
                                        context,
                                        listen: false,
                                      ).updateUVfromTime(
                                        index: index,
                                      );
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 4.0,
                                        vertical: 8.0,
                                      ),
                                      child: Neumorphic(
                                        style: NeumorphicStyle(
                                          color: state.timeColor[index],
                                          shape: NeumorphicShape.concave,
                                          lightSource: LightSource.bottom,
                                          border: NeumorphicBorder(
                                            color: _textColor(context),
                                            width: 1.0,
                                          ),
                                          depth: -10.0,
                                        ),
                                        child: Container(
                                          alignment: Alignment.center,
                                          width: 75,
                                          child: Text(
                                            state.twelveHourDates[index],
                                            style: TextStyle(
                                              color: _textColor(context),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                                itemCount: state.integers.length,
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String getTimeString(int value) {
    final int hour = value ~/ 60;
    final int minutes = value % 60;
    return '${hour.toString().padLeft(2, "0")}:${minutes.toString().padLeft(2, "0")}';
  }

  Color _textColor(BuildContext context) {
    if (NeumorphicTheme.isUsingDark(context)) {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }
}
