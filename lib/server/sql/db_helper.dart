
import 'package:avd_final_exam/Modal/student_modal.dart';
import 'package:path/path.dart' as path;
import 'package:sqflite/sqflite.dart';

class DbHelper {
  DbHelper._();

  static DbHelper dbHelper = DbHelper._();

  Database? _database;
  final tableName = 'std';

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    else {
      _database = await createDataTable();
      return _database;
    }
  }

  Future<Database> createDataTable() async {
    final filePath = await getDatabasesPath();
    final dbpath = path.join(filePath, "myDb.db");

    return await openDatabase(
        dbpath, version: 1, onCreate: (db, version) =>
        db.execute(
            '''CREATE TABLE $tableName(
       id INTEGER PRIMARY KEY AUTOINCREMENT,
       name TEXT NOT NULL,
       attendance TEXT,
       date TEXT
      )'''
        ));
  }

  Future<void> InsertData(name, attendance, date) async {
    final db = await database;
    String sql = 'INSERT INTO $tableName(name,attendance,date) VALUES(?,?,?)';
    List r = [name, attendance, date];
    db!.rawInsert(sql, r);
  }

  Future<List<Map<String, Object?>>> readData() async {
    final db = await database;
    return await db!.query(tableName);
  }

  Future<void> deletData(int id) async {
    final db = await database;
    await db!.delete(tableName, where: 'id = ?', whereArgs: [id]);
  }

  Future<void> updateData(StudentModal todo) async {
    final db = await database;
    Map<String, dynamic> m1 = {
      'id': todo.id,
      'name': todo.name,
      'attendance': todo.attendance,
      'date': todo.date,
    };
    await db!.update(tableName,m1,where: 'id = ?',whereArgs:[todo.id] );
  }
}