import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:pet_app/screens/home_screen.dart';

class HiddenDrawer extends StatefulWidget {
  const HiddenDrawer({Key key}) : super(key: key);

  @override
  State<HiddenDrawer> createState() => _HiddenDrawerState();
}

class _HiddenDrawerState extends State<HiddenDrawer> {
  List<ScreenHiddenDrawer> _pages = [];

  @override
  void initState() {
    super.initState();

    _pages = [
      ScreenHiddenDrawer(
          ItemHiddenMenu(
              name: "Pets",
              baseStyle: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 24,
              ),
              selectedStyle: TextStyle(),
              colorLineSelected: Colors.white),
          HomeScreen()),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return HiddenDrawerMenu(
      backgroundColorMenu: Color(0xFFB306060),
      screens: _pages,
      initPositionSelected: 0,
      slidePercent: 40,
    );
  }
}
