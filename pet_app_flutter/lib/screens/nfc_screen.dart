import 'package:flutter/material.dart';
import 'package:pet_app/constants/constants.dart';
import 'package:pet_app/screens/nfc_reader_screen.dart';
import 'package:pet_app/screens/nfc_writer_screen.dart';
import 'package:pet_app/screens/splash_screen.dart';

class NFC extends StatefulWidget {
  const NFC({Key key}) : super(key: key);

  @override
  State<NFC> createState() => _NFCState();
}

class _NFCState extends State<NFC> {
  @override
  Widget build(BuildContext context) {
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
              child: PrimaryButton(
                buttonText: 'Запись метки',
                press: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NFCWriter(),
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: FractionalOffset.bottomCenter,
            child: Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: PrimaryButton(
                buttonText: 'Чтение метки',
                press: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NFCReader(),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
