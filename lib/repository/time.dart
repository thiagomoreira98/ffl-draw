import 'package:sqflite/sqflite.dart';
import 'package:ffl_draw/core/storage/sqlite.dart';
import 'package:ffl_draw/models/time.dart';

class TimeRepository {

  final Sqlite sqlite = Sqlite();

  Future<List<Time>> getTimes([bool ativo]) async {
    final Database db = await sqlite.database;
    List<Map<String, dynamic>> maps = [];

    if(ativo != null) {
      maps = await db.query("time", where: "ativo = 1", orderBy: "nome");
    }
    else {
      maps = await db.query("time", orderBy: "nome");
    }

    if(maps.isNotEmpty) {
      return List.generate(maps.length, (i) {
        return Time(
            id: maps[i]['id'],
            ativo: maps[i]['ativo'] == 1 ? true : false,
            nome: maps[i]['nome']
        );
      });
    }
    else {
      return <Time>[];
    }
  }

  Future<Time> getTimeById(int id) async {
    final Database db = await sqlite.database;
    Time time;

    final List<Map<String, dynamic>> maps = await db.query("time", where: "id = ?", whereArgs: [id]);

    if(maps.isNotEmpty) {
      time = Time(
          id: maps[0]['id'],
          ativo: maps[0]['ativo'] == 1 ? true : false,
          nome: maps[0]['nome']
      );
    }

    return time;
  }

  Future<void> insertTime(Time time) async {
    final Database db = await sqlite.database;

    await db.insert(
      'time',
      time.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateTime(Time time) async {
    final Database db = await sqlite.database;

    await db.update(
        'time',
        time.toMap(),
        where: "id = ?",
        whereArgs: [time.id]
    );
  }

  Future<void> deleteTime(int id) async {
    final db = await sqlite.database;

    await db.delete(
      'time',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}