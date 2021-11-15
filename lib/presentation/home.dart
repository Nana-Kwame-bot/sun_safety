import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:sun_safety/presentation/home_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sun_safety/presentation/stats_page.dart';
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
  List<Color> _colors = [Colors.black, Colors.grey];
  static const List<Widget> _widgetOptions = <Widget>[
    MyHomePage(),
    StatsPage(),
  ];

  void _onItemTapped(int index, context) {
    setState(() {
      _selectedIndex = index;
      _colors = List.generate(2, (index) => Colors.grey);
      _colors[index] = _textColor(context);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButtonLocation: FloatingActionButtonLocation.endDocked,
        appBar: NeumorphicAppBar(
          title: Text(
            "My UV Index",
            style: TextStyle(
              color: _textColor(context),
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
                  color: _textColor(context),
                  size: 30.0,
                ),
              ),
            ),
          ],
        ),
        floatingActionButton: NeumorphicFloatingActionButton(
          style: const NeumorphicStyle(
            depth: -10.0,
            shape: NeumorphicShape.concave,
            boxShape: NeumorphicBoxShape.circle(),
          ),
          onPressed: () {
            context.read<UvCubit>().refreshUV();
          },
          child: Center(
            child: NeumorphicIcon(
              Icons.location_on_outlined,
              style: NeumorphicStyle(
                color: _textColor(context),
              ),
              size: 30,
            ),
          ),
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
                      color: _colors[0],
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
                      color: _colors[1],
                    ),
                    onPressed: () {
                      _onItemTapped(1, context);
                    },
                    iconSize: 30.0,
                    // label: 'Home',
                  ),
                  const SizedBox(
                    width: 12.0,
                    height: 12.0,
                  )
                ],
              ),
            ),
          ),

          // currentIndex: _selectedIndex,
          // selectedItemColor: Colors.amber[800],
          // onTap: _onItemTapped,
        ),
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
