import 'dart:async';
import 'package:flutter/material.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';
import 'package:pet_app/screens/splash_screen.dart';

class NFCReader extends StatefulWidget {
  @override
  _NFCReaderState createState() => _NFCReaderState();
}

class _NFCReaderState extends State<NFCReader> {
  StreamSubscription<NDEFMessage> _stream;

  void _startScanning() {
    setState(() {
      _stream = NFC
          .readNDEF(alertMessage: "Custom message with readNDEF#alertMessage")
          .listen(
        (NDEFMessage message) {
          if (message.isEmpty) {
            print("Read empty NDEF message");
            return;
          }
          print("Read NDEF message with ${message.records.length} records");
          for (final NDEFRecord record in message.records) {
            print(
              "Record '${record.id ?? "[NO ID]"}' with TNF '${record.tnf}', type '${record.type}', payload '${record.payload}' and data '${record.data}' and language code '${record.languageCode}'",
            );
          }
        },
        onError: (error) {
          setState(() {
            _stream = null;
          });
          if (error is NFCUserCanceledSessionException) {
            print("user canceled");
          } else if (error is NFCSessionTimeoutException) {
            print("session timed out");
          } else {
            print("error: $error");
          }
        },
        onDone: () {
          setState(() {
            _stream = null;
          });
        },
      );
    });
  }

  void _stopScanning() {
    _stream?.cancel();
    setState(() {
      _stream = null;
    });
  }

  void _toggleScan() {
    if (_stream == null) {
      _startScanning();
    } else {
      _stopScanning();
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Чтение тега"),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 20, right: 20),
            child: PrimaryButton(
              press: _toggleScan,
              buttonText: "Начать сканирование",
            ),
          ),
        ],
      ),
    );
  }
}
