import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static Database? _database;

  Future<Database> get database async {
    _database ??= await initDatabase();
    return _database!;
  }

  Future<Database> initDatabase() async {
    final String path = join(await getDatabasesPath(), 'passcode_database.db');
    return openDatabase(path, version: 1, onCreate: (db, version) async {
      await db.execute(
        'CREATE TABLE passcode(id INTEGER PRIMARY KEY, passcode TEXT)',
      );
    },);
  }

  Future<void> setPasscode(String passcode) async {
    final Database db = await database;
    await db.insert(
      'passcode',
      {'id': 1, 'passcode': passcode},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<String?> getPasscode() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps =
        await db.query('passcode', where: 'id = 1');
    if (maps.isNotEmpty) {
      return maps.first['passcode'];
    }
    return null;
  }
}
