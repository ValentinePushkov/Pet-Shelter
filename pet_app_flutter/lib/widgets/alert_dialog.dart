import 'package:flutter/material.dart';
import 'package:pet_app/constants/constants.dart';

enum DialogsAction { yes, cancel }

class AlertDialogsClass {
  static Future<DialogsAction> logoutDialog(
    BuildContext context,
    String title,
    String body,
  ) async {
    final action = await showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            title,
            style: TextStyle(
              color:
                  MediaQuery.platformBrightnessOf(context) == Brightness.light
                      ? Theme.of(context).primaryColor
                      : Constants.kSecondaryColor,
            ),
          ),
          content: Text(body),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(DialogsAction.cancel),
              child: Text(
                'No',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: MediaQuery.platformBrightnessOf(context) ==
                          Brightness.light
                      ? Theme.of(context).primaryColor
                      : Constants.kSecondaryColor,
                ),
              ),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(DialogsAction.yes),
              child: Text(
                'Yes',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: MediaQuery.platformBrightnessOf(context) ==
                          Brightness.light
                      ? Theme.of(context).primaryColor
                      : Constants.kSecondaryColor,
                ),
              ),
            ),
          ],
        );
      },
    );
    return action != null ? action : DialogsAction.cancel;
  }
}
