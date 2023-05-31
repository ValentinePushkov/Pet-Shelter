import 'package:flutter/material.dart';
import 'package:pet_app/constants/constants.dart';
import 'package:pet_app/providers/nfc_provider.dart';
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
  TabController _tabController;
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _tabController = new TabController(length: 2, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    var nfcProvider = Provider.of<NFCProvider>(context);
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
                'NFC: ' +
                    nfcProvider.checkAvailability(nfcProvider.availability),
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
                press: () => nfcProvider.scanTag(databaseMethods, context),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
