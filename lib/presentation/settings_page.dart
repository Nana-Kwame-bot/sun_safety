import 'dart:developer';
import 'package:direct_select_flutter/direct_select_container.dart';
import 'package:direct_select_flutter/direct_select_item.dart';
import 'package:direct_select_flutter/direct_select_list.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sun_safety/repository/uv_repository.dart';
import 'package:sun_safety/theme/cubit/theme_cubit.dart';
import 'package:sun_safety/uv/cubit/uv_cubit.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  int _selectedIndex = 0;
  @override
  Widget build(BuildContext context) {
    return DirectSelectContainer(
      decoration: BoxDecoration(
        color: NeumorphicTheme.baseColor(context),
      ),
      child: LayoutBuilder(builder: (context, constraints) {
        return Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              height: constraints.maxHeight * 0.075,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Theme",
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: _textColor(context),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 8.0,
              ),
              child: NeumorphicToggle(
                selectedIndex: _selectedIndex,
                height: constraints.maxHeight * 0.1,
                onAnimationChangedFinished: (int? index) {
                  BlocProvider.of<ThemeCubit>(context).changeTheme(
                    index: index!,
                  );
                },
                onChanged: (int? index) {
                  setState(() {
                    _selectedIndex = index!;
                  });
                },
                thumb: Neumorphic(
                  style: NeumorphicStyle(
                    depth: 10.0,
                    boxShape: NeumorphicBoxShape.roundRect(
                      BorderRadius.circular(12),
                    ),
                  ),
                ),
                children: [
                  ToggleElement(
                    background: Center(
                      child: Text(
                        "System",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: _textColor(context),
                        ),
                      ),
                    ),
                    foreground: Center(
                      child: Text(
                        "System",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: _textColor(context),
                        ),
                      ),
                    ),
                  ),
                  ToggleElement(
                    background: Center(
                      child: Text(
                        "Light",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: _textColor(context),
                        ),
                      ),
                    ),
                    foreground: Center(
                      child: Text(
                        "Light",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: _textColor(context),
                        ),
                      ),
                    ),
                  ),
                  ToggleElement(
                    background: Center(
                      child: Text(
                        "Dark",
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: _textColor(context),
                        ),
                      ),
                    ),
                    foreground: Center(
                      child: Text(
                        "Dark",
                        style: TextStyle(
                          fontWeight: FontWeight.w700,
                          color: _textColor(context),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: constraints.maxHeight * 0.1,
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
            // SizedBox(
            //   height: constraints.maxHeight * 0.075,
            //   child: const Align(
            //     alignment: Alignment.center,
            //     child: Text(
            //       "For safe exposure time calculation",
            //       style: TextStyle(
            //         fontSize: 20.0,
            //         fontWeight: FontWeight.bold,
            //         color: Colors.grey,
            //       ),
            //     ),
            //   ),
            // ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 8.0,
              ),
              child: Neumorphic(
                style: const NeumorphicStyle(
                  shape: NeumorphicShape.concave,
                  depth: -10.0,
                ),
                child: BlocBuilder<UvCubit, UVState>(
                  builder: (context, state) {
                    return DirectSelectList(
                      onUserTappedListener: () {
                        log("hello");
                      },
                      onItemSelectedListener:
                          (dynamic item, int index, BuildContext context) {
                        BlocProvider.of<UvCubit>(context, listen: false)
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
              height: constraints.maxHeight * 0.25,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 24.0,
                vertical: 24.0,
              ),
              child: Neumorphic(
                style: const NeumorphicStyle(
                  shape: NeumorphicShape.concave,
                  depth: -20.0,
                ),
                child: ListTile(
                  title: Text(
                    "More Info",
                    style: TextStyle(
                      color: _textColor(context),
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  onTap: () {
                    showAboutDialog(context: context);
                  },
                ),
              ),
            ),
          ],
        );
      }),
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
