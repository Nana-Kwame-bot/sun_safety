import 'package:awesome_dropdown/awesome_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sun_safety/address/cubit/address_cubit.dart';
import 'package:sun_safety/uv/cubit/uv_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:scrollable_positioned_list/scrollable_positioned_list.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
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
                  child: BlocBuilder<AddressCubit, AddressState>(
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
                          SizedBox(
                            height: constraints.maxHeight * 0.1,
                            child: AwesomeDropDown(
                              dropDownBorderRadius: 50,
                              isBackPressedOrTouchedOutSide: true,
                              elevation: 12.0,
                              dropDownOverlayBGColor:
                                  NeumorphicTheme.baseColor(context),
                              dropDownBGColor:
                                  NeumorphicTheme.baseColor(context),
                              selectedItem: "Cloud Coverage",
                              dropDownList: const [
                                "Hello",
                                "Hello",
                                "Hello",
                                "Hello",
                                "Hello",
                              ],
                              numOfListItemToShow: 5,
                              selectedItemTextStyle: TextStyle(
                                fontSize: 18.0,
                                color: _textColor(context),
                              ),
                              dropDownListTextStyle: TextStyle(
                                fontSize: 16.0,
                                color: _textColor(context),
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.only(
                              right: 24.0,
                            ),
                            height: constraints.maxHeight * 0.575,
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
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    AnimatedSwitcher(
                                      duration:
                                          const Duration(milliseconds: 250),
                                      child: Text(
                                        state.currentUV.toStringAsFixed(2),
                                        key: ValueKey(state.currentUV),
                                        style: TextStyle(
                                          fontSize: 60.0,
                                          color: state.currentUVColor,
                                        ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    SizedBox(
                                      height: constraints.maxHeight * 0.025,
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
                          SizedBox(
                            height: constraints.maxHeight * 0.075,
                          )
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

  // Color? _getTimeColor({required UVState state, required int index}) {
  //   if (_selectedIndex == index) {
  //     return state.currentUVColor.withOpacity(0.5);
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
