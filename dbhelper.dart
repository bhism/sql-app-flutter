import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'model.dart';

class DatabaseHandler {
  Future<Database> initializeDB() async {
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, 'tododatabase.db'),
      onCreate: (database, version) async {
        await database.execute(
          'CREATE TABLE todos(id INTEGER PRIMARY KEY, title TEXT, description TEXT)',
        );
      },
      version: 1,
    );
  }

  Future<void> inserttodo(todo todo) async {
    final db = await initializeDB();
    await db.insert(
      'todos',
      todo.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<todo>> todos() async {
    final db = await initializeDB();
    final List<Map<String, dynamic>> queryResult = await db.query('todos');
    return queryResult.map((e) => todo.fromMap(e)).toList();
  }

  Future<void> deletetodo(int id) async {
    final db = await initializeDB();
    await db.delete(
      'todos',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
