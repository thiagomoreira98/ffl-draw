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
        db.execute(
          "CREATE TABLE time("
            "id INTEGER PRIMARY KEY,"
            "ativo BOOLEAN NOT NULL,"
            "nome VARCHAR(50) NOT NULL"
          ")"
        );

        db.execute(
          "CREATE TABLE selecao("
            "id INTEGER PRIMARY KEY,"
            "ativo BOOLEAN NOT NULL,"
            "nome VARCHAR(50) NOT NULL"
          ")"
        );

        db.execute(
          "CREATE TABLE player("
            "id INTEGER PRIMARY KEY,"
            "ativo BOOLEAN NOT NULL,"
            "nome VARCHAR(100) NOT NULL,"
            "idpsn VARCHAR(50),"
            "idtime INTEGER,"
            "idselecao INTEGER,"
            "CONSTRAINT fk_player_time FOREIGN KEY(idtime) references time(id),"
            "CONSTRAINT fk_player_selecao FOREIGN KEY(idselecao) references selecao(id)"
          ")"
        );
      },
      version: 1
    );
  }
}
