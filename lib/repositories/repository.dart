import 'package:xzone/repositories/DataBase.dart';

import 'package:sqflite/sqflite.dart';

class Repositery {
  DatabaseConnection _databaseConnection;
  Repositery() {
    _databaseConnection = DatabaseConnection();
  }
  static Database _dataBase;
  Future<Database> get database async {
    if (_dataBase != null) return _dataBase;
    _dataBase = await _databaseConnection.setDatabase();
    return _dataBase;
  }

  insertData(table, data) async {
    var connection = await database;
    return await connection.insert(table, data);
  }

  readData(table) async {
    var connection = await database;
    return await connection.query(table);
  }
}
