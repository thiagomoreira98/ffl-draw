import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class Sqlite {
  Database _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database;
    } else {
      _database = await init();
      return _database;
    }
  }

  init() async {
    var databasePath = await getDatabasesPath();
    return openDatabase(join(databasePath, 'ffl-draw.db'),
      onCreate: (db, version) {
        return db.execute("CREATE TABLE player(id INTEGER PRIMARY KEY, ativo BOOLEAN, nome VARCHAR(150), idpsn VARCHAR(50))");
      },
      version: 1
    );
  }
}
