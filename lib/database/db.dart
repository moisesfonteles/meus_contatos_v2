
import 'dart:developer';

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DB {
  DB._();
  static final DB instance = DB._();
  static Database? _database;

  Future<Database> database() async {
    if(_database != null) return _database!;

    return await _initDataBase();
  }

  Future<Database> _initDataBase() async{
    return await openDatabase(
      join(await getDatabasesPath(), 'meuscontatos.db'),
      version: 1,
      onCreate: _onCreate,
      
    );
  }

  _onCreate(Database db, int version) async{
    await Future.wait([
      db.execute(_contact),
      db.execute(_address)
    ]);
  }

  String get _contact {
    return "CREATE TABLE IF NOT EXISTS contact (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, name TEXT, phone TEXT, email TEXT, contact_id INTEGER);";
  }

  String get _address {
    return "CREATE TABLE IF NOT EXISTS address (id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL, suite TEXT, street TEXT, city TEXT, latitude TEXT, longitude TEXT, contact_id INTEGER);";
  }

  Future<void> insertTheContacts(Database db) async{ // Insere dados no banco
    await db.rawInsert(
      "INSERT INTO contact(name, phone, email, contact_id) VALUES('Moisés Fonteles', '+55 (85) 9 9256-3380', 'moisesfonteles18@gmail.com', '2');"
    );
  }

  Future<List<Map>> getTheContacts(Database db) async{ // printa dados do banco
    List<Map> list = await db.rawQuery("SELECT * FROM contact");
    log("$list");
    return list;
  }

  Future<void> updateTheContacts(Database db) async{ // Altera dados no banco
    await db.rawUpdate("UPDATE contact SET name = 'Italo Moreira' WHERE id = 1;");
  }

  Future<void> deleteTheContact(Database db) async{ // Exclui dados do banco
    await db.rawDelete("DELETE FROM contact;");
  }

}