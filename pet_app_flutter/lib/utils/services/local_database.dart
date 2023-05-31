import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class LocalDatabase {
  static final LocalDatabase db = LocalDatabase();
  Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initDB();
    return _database;
  }

  initDB() async {
    Directory documentsDirectory = await getApplicationSupportDirectory();
    String path = join(documentsDirectory.path, 'TestDB.db');
    return await openDatabase(
      path,
      version: 1,
      onOpen: (db) {},
      onCreate: (Database db, int version) async {
        await db.execute(
          'CREATE TABLE KEYS ('
          'id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,'
          'username TEXT,'
          'privateKey TEXT'
          ')',
        );
      },
    );
  }

  addKey(String username, String privateKey) async {
    final db = await database;
    var raw = await db.rawInsert(
      'INSERT Into KEYS (username ,privateKey )'
      ' VALUES (?,?)',
      [username, privateKey],
    );
    return raw;
  }

  getKey(String username) async {
    final db = await database;
    var raw = await db
        .rawQuery('SELECT privateKey FROM KEYS WHERE username = ?', [username]);
    return raw.isNotEmpty ? raw.first['privateKey'] : "";
  }
}
