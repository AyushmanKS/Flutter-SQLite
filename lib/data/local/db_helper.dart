import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  // singleton
  DBHelper._();

  static final DBHelper getInstance = DBHelper._();

  // check and open db
  Database? myDB;

// checking weather new database creaton is required or not
  Future<Database> getDB() async {
    if (myDB != null) {
      return myDB!;
    } else {
      myDB = await openDB();
      return myDB!;
    }
  }

  Future<Database> openDB() async {
    Directory appDir =
        await getApplicationDocumentsDirectory(); // application directory path
    String dbPath = join(appDir.path, "noteDB.db");

    return await openDatabase(dbPath, onCreate: (db, version) {
      // create all the tables
    }, version: 1);
  }
}
