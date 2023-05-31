import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_nfc_kit/flutter_nfc_kit.dart';
import 'package:pet_app/constants/constants.dart';
import 'package:pet_app/screens/pet_details.dart';
import 'package:pet_app/utils/services/database.dart';

class NFCProvider extends ChangeNotifier {
  NFCAvailability _availability = NFCAvailability.not_supported;

  NFCProvider() {
    initPlatformState();
  }

  NFCAvailability get availability => _availability;

  Future<void> initPlatformState() async {
    NFCAvailability availability;
    try {
      availability = await FlutterNfcKit.nfcAvailability;
    } on PlatformException {
      availability = NFCAvailability.not_supported;
    }
    _availability = availability;
    notifyListeners();
  }

  String checkAvailability(NFCAvailability availability) {
    if (availability == NFCAvailability.available) {
      return Constants.nfcAvaliable;
    } else {
      return Constants.nfcUnavaliable;
    }
  }

  void scanTag(DatabaseMethods databaseMethods, BuildContext context) async {
    try {
      SnackBar snackBar = SnackBar(
        content: Text(
          Constants.scanTag,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      );
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      });
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
            Constants.adNotFound,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Colors.red,
        );

        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (e) {
      return;
    }

    if (!kIsWeb) sleep(new Duration(seconds: 1));
    await FlutterNfcKit.finish(iosAlertMessage: "Finished!");
  }
}
