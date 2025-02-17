
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';



class DatabaseHelper {
  DatabaseHelper._();

  static DatabaseHelper databaseHelper = DatabaseHelper._();

  Database? _database;
  String databaseName = 'student.db';
  String tableName = 'student';

  Future<Database> get database async => _database ?? await initDatabase();
// craete table
  Future<Database> initDatabase() async {
    final path = await getDatabasesPath();
    final dbPath = join(path, databaseName);
    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) {
        String sql = '''
        CREATE TABLE $tableName (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name TEXT NOT NULL,
          attendance TEXT NOT NULL,
          date TEXT NOT NULL,
        )
        ''';
        db.execute(sql);
      },
    );
  }
// add student

  Future<int> addStudent(String name, String attendance, String date) async {
    final db = await database;
    String sql = '''
    INSERT INTO $tableName(
    name, attendance, date
    ) VALUES (?, ?, ?)
    ''';
    List args = [name, attendance, date];
    return await db.rawInsert(sql, args);
  }
// fetch all data
  Future<List<Map<String, Object?>>> readAll() async {
    final db = await database;
    String sql = '''
    SELECT * FROM $tableName
    ''';
    return await db.rawQuery(sql);
  }
// update data
  Future<int> update(
      int id, String name, String attendance, String date) async {
    final db = await database;
    String sql = '''
    UPDATE $tableName SET name = ?, attendance = ?, date = ? WHERE id = ?
    ''';
    List args = [id, name, attendance, date];
    return await db.rawUpdate(sql, args);
  }
//delete data
  Future<int> delete(int id) async {
    final db = await database;
    String sql = '''  
    DELETE FROM $tableName WHERE id = ?
    ''';
    List args = [id];
    return await db.rawDelete(sql, args);
  }
}
