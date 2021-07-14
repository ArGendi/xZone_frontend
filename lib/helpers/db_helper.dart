import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'dart:io' as io;

import 'package:xzone/constants.dart';

class DBHelper {
  static sql.Database _db;
  static const String DB_NAME = 'xZone';

  Future<sql.Database> get db async {
    if(_db != null) return _db;
    _db = await initDB();
    return _db;
  }

  initDB() async{
    io.Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String dbPath = path.join(documentsDirectory.path, DB_NAME);
    var db = await sql.openDatabase(dbPath, version: 1, onCreate: _onCreate);
    return db;
  }

  _onCreate(sql.Database db, int version) async{
    await db.execute('''CREATE TABLE tasks(id INTEGER PRIMARY KEY, userId INTEGER,
                     parentId INTEGER, name TEXT, dueDate TEXT, remainder TEXT,
                     completeDate TEXT, priority INTEGER, sectionId INTEGER,
                     projectId INTEGER)''');
    await  db.execute('''CREATE TABLE sections(id INTEGER PRIMARY KEY, name TEXT, 
                      projectId INTEGER)''');
    await  db.execute('''CREATE TABLE projects(id INTEGER PRIMARY KEY, userId INTEGER,
                      name TEXT)''');
  }

  Future<void> insert(String table,Map<String, Object> data) async{
    var dbClient = await db;
    await dbClient.insert(table, data);
  }

  Future<List<Map>> getData(String table) async{
    var dbClient = await db;
    return dbClient.query(table);
  }

  Future<void> deleteRow(String table, int id) async{
    var dbClient = await db;
    await dbClient.delete(table, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateRow(String table, int id, Map<String, dynamic> newData) async{
    var dbClient = await db;
    await dbClient.update(
        table,
        newData,
        where: 'id = ?',
        whereArgs: [id]
    );
  }

  Future<List<Map>> getNormalTasks () async{
    var dbClient = await db;
    List<Map> result = await dbClient.rawQuery('SELECT * FROM $tasksTable WHERE projectId=?', [0]);
    return result;
  }

  Future<List<Map>> getSectionsOfProject (int id) async{
    var dbClient = await db;
    List<Map> result = await dbClient.rawQuery('SELECT * FROM $sectionsTable WHERE projectId=?', [id]);
    return result;
  }

  Future<List<Map>> getTasksOfSection (int sectionId, int projectId) async{
    var dbClient = await db;
    List<Map> result = await dbClient.rawQuery('SELECT * FROM $tasksTable WHERE sectionId=? AND projectId=?', [sectionId, projectId]);
    return result;
  }

  Future<void> deleteAllRowsRelatedToProject(String table, int id) async{
    var dbClient = await db;
    await dbClient.delete(table, where: 'projectId = ?', whereArgs: [id]);
  }

  Future<void> deleteAllRowsRelatedToSection(String table, int id) async{
    var dbClient = await db;
    await dbClient.delete(table, where: 'sectionId = ?', whereArgs: [id]);
  }
}