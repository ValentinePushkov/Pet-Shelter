import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:nfc_in_flutter/nfc_in_flutter.dart';
import 'package:pet_app/constants/constants.dart';

class RecordEditor {
  final TextEditingController mediaTypeController = TextEditingController();
  final TextEditingController payloadController = TextEditingController();
}

class NFCWriter extends StatefulWidget {
  @override
  _NFCWriterState createState() => _NFCWriterState();
}

class _NFCWriterState extends State<NFCWriter> {
  StreamSubscription<NDEFMessage> _stream;
  List<RecordEditor> _records = [];
  bool _hasClosedWriteDialog = false;

  void _addRecord() {
    setState(() {
      _records.add(RecordEditor());
    });
  }

  void _write(BuildContext context) async {
    List<NDEFRecord> records = _records.map((record) {
      return NDEFRecord.type(
        record.mediaTypeController.text,
        record.payloadController.text,
      );
    }).toList();
    NDEFMessage message = NDEFMessage.withRecords(records);

    // Show dialog on Android (iOS has it's own one)
    if (Platform.isAndroid) {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text("Отсканируйте тег для записи"),
          actions: <Widget>[
            TextButton(
              child: Text(
                "Отмена",
                style: TextStyle(color: Constants.kPrimaryColor),
              ),
              onPressed: () {
                _hasClosedWriteDialog = true;
                _stream?.cancel();
                Navigator.pop(context);
              },
            ),
          ],
        ),
      );
    }

    // Write to the first tag scanned
    await NFC.writeNDEF(message).first;
    if (!_hasClosedWriteDialog) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Запись метки"),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          Center(
            child: OutlinedButton(
              style: OutlinedButton.styleFrom(
                shape: StadiumBorder(),
                side: BorderSide(color: Constants.kPrimaryColor),
              ),
              onPressed: _addRecord,
              child: Text(
                "Добавить запись",
                style: TextStyle(color: Constants.kPrimaryColor),
              ),
            ),
          ),
          for (var record in _records)
            Padding(
              padding: const EdgeInsets.only(bottom: 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Запись",
                    style: TextStyle(
                      color: Constants.kPrimaryColor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextFormField(
                    controller: record.mediaTypeController,
                    decoration: InputDecoration(
                      hintText: "Тип медиа",
                    ),
                  ),
                  TextFormField(
                    controller: record.payloadController,
                    decoration: InputDecoration(
                      hintText: "Пейлоуд",
                    ),
                  )
                ],
              ),
            ),
          Center(
            child: ElevatedButton(
              onPressed: _records.length > 0 ? () => _write(context) : null,
              child: const Text("Записать тег"),
            ),
          ),
        ],
      ),
    );
  }
}
