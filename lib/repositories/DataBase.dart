import 'package:sqflite/sqflite.dart';

import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DatabaseConnection {
  setDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'xZoonLocalDatabase');
    var database =
        await openDatabase(path, version: 1, onCreate: _onCreatingDatabase);
    return database;
  }

  void _onCreatingDatabase(Database database, int version) async {
    String sql =
        "CREATE TABLE Tasks(id INTEGER PRIMARY KEY,name TEXT,userid INTEGER,parentid INTEGER,priority INTEGER,dueDate TEXT,completeDate TEXT,remainder TEXT)";
    await database.execute(sql);
  }
}
