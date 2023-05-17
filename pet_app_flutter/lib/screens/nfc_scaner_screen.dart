import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:pet_app/constants/constants.dart';
import 'package:pet_app/screens/pet_details.dart';
import 'package:pet_app/screens/splash_screen.dart';
import 'package:pet_app/utils/services/database.dart';
import 'package:provider/provider.dart';

class NFCScaner extends StatefulWidget {
  const NFCScaner({Key key}) : super(key: key);

  @override
  State<NFCScaner> createState() => _NFCScanerState();
}

class _NFCScanerState extends State<NFCScaner>
    with SingleTickerProviderStateMixin {
  NFCAvailability _availability = NFCAvailability.not_supported;
  TabController _tabController;
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    initPlatformState();
    _tabController = new TabController(length: 2, vsync: this);
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    NFCAvailability availability;
    try {
      availability = await FlutterNfcKit.nfcAvailability;
    } on PlatformException {
      availability = NFCAvailability.not_supported;
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      // _platformVersion = platformVersion;
      _availability = availability;
    });
  }

  String checkAvailability(NFCAvailability availability) {
    if (availability == NFCAvailability.available) {
      return 'Доступен';
    } else {
      return 'Недоступен(включите NFC и перезагрузите страницу)';
    }
  }

  void scanTag(DatabaseMethods databaseMethods) async {
    try {
      SnackBar snackBar = SnackBar(
        content: Text(
          'Отсканируйте метку',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      NFCTag tag = await FlutterNfcKit.poll();
      var homelessPet = await databaseMethods.getPetByTagID(tag.id);
      if (homelessPet != null) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => PetDetails(
              petDetailsMap: homelessPet,
            ),
          ),
        );
      } else {
        SnackBar snackBar = SnackBar(
          content: Text(
            'Объявление не найдено.',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      return;
    }

    // Pretend that we are working
    if (!kIsWeb) sleep(new Duration(seconds: 1));
    await FlutterNfcKit.finish(iosAlertMessage: "Finished!");
  }

  @override
  Widget build(BuildContext context) {
    var databaseMethods = Provider.of<DatabaseMethods>(context);
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 24, right: 24, bottom: 20),
            child: Text(
              'Обезопасте себя от потери питомца с помощью NFC метки',
              style: TextStyle(
                color: Constants.kPrimaryColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(16),
            child: Center(
              child: Image.asset("images/nfc3.png"),
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Align(
            alignment: FractionalOffset.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'NFC: ' + checkAvailability(_availability),
                style: TextStyle(
                  color: Constants.kPrimaryColor,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          Align(
            alignment: FractionalOffset.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: PrimaryButton(
                buttonText: 'Считать метку',
                press: () => scanTag(databaseMethods),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
