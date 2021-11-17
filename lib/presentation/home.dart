import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sun_safety/presentation/home_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_safety/presentation/settings_page.dart';
import 'package:sun_safety/presentation/stats_page.dart';
import 'package:sun_safety/repository/uv_repository.dart';
import 'package:sun_safety/uv/cubit/uv_cubit.dart';

/// This is the stateful widget that the main application instantiates.
class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _MyStatefulWidgetState();
}

/// This is the private State class that goes with Home.
class _MyStatefulWidgetState extends State<Home> {
  int _selectedIndex = 0;

  static const List<Widget> _widgetOptions = <Widget>[
    MyHomePage(),
    StatsPage(),
    SettingsPage(),
  ];

  void _onItemTapped(int index, context) {
    setState(() {
      _selectedIndex = index;
    });
  }

  String getTitle() {
    switch (_selectedIndex) {
      case 0:
        return "My UV index";
      case 1:
        return "Statistics";
      case 2:
        return "Settings";
      default:
        return "";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: NeumorphicAppBar(
          title: Text(
            getTitle(),
            style: TextStyle(
              color: _textColor(context: context),
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            NeumorphicButton(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              onPressed: () {
                NeumorphicTheme.of(context)!.themeMode =
                    NeumorphicTheme.isUsingDark(context)
                        ? ThemeMode.light
                        : ThemeMode.dark;
              },
              style: const NeumorphicStyle(
                depth: -10.0,
                shape: NeumorphicShape.concave,
                boxShape: NeumorphicBoxShape.circle(),
              ),
              child: Center(
                child: Icon(
                  NeumorphicTheme.isUsingDark(context)
                      ? Icons.light_mode
                      : Icons.dark_mode,
                  color: _textColor(context: context),
                  size: 30.0,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: NeumorphicTheme.baseColor(context),
        body: Center(
          child: IndexedStack(
            index: _selectedIndex,
            children: _widgetOptions,
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          notchMargin: 8.0,
          elevation: 12.0,
          color: NeumorphicTheme.baseColor(context),
          shape: const CircularNotchedRectangle(),
          child: Neumorphic(
            drawSurfaceAboveChild: false,
            style: const NeumorphicStyle(
              depth: 10.0,
              shape: NeumorphicShape.flat,
            ),
            child: SizedBox(
              height: 56.0,
              child: Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  //use neumorphic checkbox / radio with accent color
                  IconButton(
                    icon: Icon(
                      Icons.home,
                      color: _textColorButton(context: context, index: 0),
                    ),
                    onPressed: () {
                      _onItemTapped(0, context);
                    },
                    iconSize: 30.0,
                    // label: 'Home',
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.query_stats,
                      color: _textColorButton(context: context, index: 1),
                    ),
                    onPressed: () {
                      _onItemTapped(1, context);
                    },
                    iconSize: 30.0,
                    // label: 'Home',
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.tune,
                      color: _textColorButton(context: context, index: 2),
                    ),
                    onPressed: () {
                      _onItemTapped(2, context);
                    },
                    iconSize: 30.0,
                    // label: 'Home',
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // Route _settingsRoute() {
  //   return PageRouteBuilder(
  //     pageBuilder: (_, animation, secondaryAnimation) {
  //       return const SettingsPage();
  //     },
  //     transitionsBuilder: (_, animation, secondaryAnimation, child) {
  //       const begin = Offset(1.0, 0.0);
  //       const end = Offset.zero;
  //       const curve = Curves.ease;

  //       var tween =
  //           Tween(begin: begin, end: end).chain(CurveTween(curve: curve));

  //       return SlideTransition(
  //         position: animation.drive(tween),
  //         child: child,
  //       );
  //     },
  //   );
  // }

  Color _textColorButton({required BuildContext context, required int index}) {
    if (NeumorphicTheme.isUsingDark(context)) {
      if (index == _selectedIndex) {
        return Colors.white;
      }
      return Colors.grey;
    } else {
      if (index == _selectedIndex) {
        return Colors.black;
      }
      return Colors.grey;
    }
  }

  Color _textColor({required BuildContext context}) {
    if (NeumorphicTheme.isUsingDark(context)) {
      return Colors.white;
    } else {
      return Colors.black;
    }
  }
}
