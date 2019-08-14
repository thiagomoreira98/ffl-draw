import 'package:sqflite/sqflite.dart';
import 'package:ffl_draw/core/storage/sqlite.dart';
import 'package:ffl_draw/models/player.dart';

class PlayerRepository {

  final Sqlite sqlite = Sqlite();

  Future<List<Player>> getPlayers() async {
    final Database db = await sqlite.database;

    final List<Map<String, dynamic>> maps = await db.query('player');
    return List.generate(maps.length, (i) {
      return Player(
        id: maps[i]['id'],
        ativo: maps[i]['ativo'] == 1 ? true : false,
        nome: maps[i]['nome'],
        idPsn: maps[i]['idpsn'],
      );
    });
  }

  Future<Player> getPlayerById(int id) async {
    final Database db = await sqlite.database;
    Player player;

    final List<Map<String, dynamic>> maps = await db.query("player", where: "id = ?", whereArgs: [id]);

    if(maps.isNotEmpty) {
      player = Player(
        id: maps[0]['id'],
        ativo: maps[0]['ativo'] == 1 ? true : false,
        nome: maps[0]['nome'],
        idPsn: maps[0]['idpsn'],
      );
    }

    return player;
  }

  Future<void> insertPlayer(Player player) async {
    final Database db = await sqlite.database;

    await db.insert(
      'player',
      player.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updatePlayer(Player player) async {
    final Database db = await sqlite.database;

    await db.update(
        'player',
        player.toMap(),
        where: "id = ?",
        whereArgs: [player.id]
    );
  }

  Future<void> deletePlayer(int id) async {
    final db = await sqlite.database;

    await db.delete(
      'player',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}