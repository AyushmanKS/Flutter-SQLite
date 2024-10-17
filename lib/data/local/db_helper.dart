import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  // singleton
  DBHelper._();

  static final DBHelper getInstance = DBHelper._();

  final String TABLE_NOTE = "note";
  final String COLUMN_NOTE_SNO = "s_no";
  final String COLUMN_NOTE_TITLE = "title";
  final String COLUMN_NOTE_DESC = "desc";

  // check and open db
  Database? myDB;

// checking weather new database creaton is required or not
  Future<Database> getDB() async {
    myDB = myDB ?? await openDB();
    return myDB!;
  }

  Future<Database> openDB() async {
    Directory appDir =
        await getApplicationDocumentsDirectory(); // application directory path
    String dbPath = join(appDir.path, "noteDB.db");

    return await openDatabase(dbPath, onCreate: (db, version) {
      // create all the tables
      db.execute(
          "create table $TABLE_NOTE ($COLUMN_NOTE_SNO integer primary key autoincriment, $COLUMN_NOTE_TITLE text, $COLUMN_NOTE_DESC)");
    }, version: 1);
  }

  // all queries-----------------------------------------------------------------------------------------------------------------------

  // add note
  Future<bool> addNote({required String mTitle, required String mDesc}) async {
    var db = await getDB();
    int rowsEffected = await db.insert(TABLE_NOTE, {
      COLUMN_NOTE_TITLE: mTitle,
      COLUMN_NOTE_DESC: mDesc,
    });
    return rowsEffected > 0;
  }

  // get notes
  Future<List<Map<String, dynamic>>> getAllNotes() async {
    var db = await getDB();
    List<Map<String, dynamic>> myData = await db.query(
      TABLE_NOTE,
    );
    return myData;
  }
}
