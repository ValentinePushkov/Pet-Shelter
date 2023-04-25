import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:pet_app/screens/active_pets_screen.dart';
import 'package:pet_app/screens/moderation_screen.dart';
import 'package:pet_app/screens/profile_screen.dart';

class AdminHiddenDrawer extends StatefulWidget {
  const AdminHiddenDrawer({Key key}) : super(key: key);

  @override
  State<AdminHiddenDrawer> createState() => _AdminHiddenDrawerState();
}

class _AdminHiddenDrawerState extends State<AdminHiddenDrawer> {
  List<ScreenHiddenDrawer> _pages = [];

  @override
  void initState() {
    super.initState();

    _pages = [
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: "Модерация\nобъявлений",
          baseStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
          selectedStyle: TextStyle(),
          colorLineSelected: Colors.white,
        ),
        ModerationScreen(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: "Активыне\nобъявления",
          baseStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
          selectedStyle: TextStyle(),
          colorLineSelected: Colors.white,
        ),
        ActivePetsScreen(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: "Профиль",
          baseStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
          selectedStyle: TextStyle(),
          colorLineSelected: Colors.white,
        ),
        ProfileScreen(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return HiddenDrawerMenu(
      backgroundColorMenu: Color(0xFFB306060),
      screens: _pages,
      initPositionSelected: 0,
      slidePercent: 50,
    );
  }
}
