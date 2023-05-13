import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';
import 'package:pet_app/constants/constants.dart';
import 'package:pet_app/screens/adding_pet_screen.dart';
import 'package:pet_app/screens/chat_rooms_screen.dart';
import 'package:pet_app/screens/home_screen.dart';
import 'package:pet_app/screens/my_ads_screen.dart';
import 'package:pet_app/screens/nfc_reader_screen.dart';
import 'package:pet_app/screens/nfc_screen.dart';
import 'package:pet_app/screens/profile_screen.dart';
import 'package:pet_app/screens/qr_generator_screen.dart';
import 'package:pet_app/utils/helpers/shared_pref_helper.dart';

class HiddenDrawer extends StatefulWidget {
  const HiddenDrawer({Key key}) : super(key: key);

  @override
  State<HiddenDrawer> createState() => _HiddenDrawerState();
}

class _HiddenDrawerState extends State<HiddenDrawer> {
  List<ScreenHiddenDrawer> _pages = [];

  setLoggedInUsername() async {
    await SharedPrefHelper().getUsernameSharedPref().then((val) {
      setState(() {
        Constants.currentUser = val;
      });
    });
  }

  @override
  void initState() {
    setState(() {
      setLoggedInUsername();
    });
    super.initState();

    _pages = [
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: "Питомцы",
          baseStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
          selectedStyle: TextStyle(),
          colorLineSelected: Colors.white,
        ),
        HomeScreen(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: "Создать\nобъявление",
          baseStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
          selectedStyle: TextStyle(),
          colorLineSelected: Colors.white,
        ),
        AddingPet(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: "Cообщения",
          baseStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
          selectedStyle: TextStyle(),
          colorLineSelected: Colors.white,
        ),
        ChatRooms(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: "Qr генератор",
          baseStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
          selectedStyle: TextStyle(),
          colorLineSelected: Colors.white,
        ),
        QrGenerator(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: "NFC сканер",
          baseStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
          selectedStyle: TextStyle(),
          colorLineSelected: Colors.white,
        ),
        NFC(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: "Мои\nобъявления",
          baseStyle: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
          selectedStyle: TextStyle(),
          colorLineSelected: Colors.white,
        ),
        MyAds(),
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
