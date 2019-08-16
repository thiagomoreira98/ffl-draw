import 'package:sqflite/sqflite.dart';
import 'package:ffl_draw/core/storage/sqlite.dart';
import 'package:ffl_draw/models/selecao.dart';

class SelecaoRepository {

  final Sqlite sqlite = Sqlite();

  Future<List<Selecao>> getSelecoes([bool ativo]) async {
    final Database db = await sqlite.database;
    List<Map<String, dynamic>> maps = [];

    if(ativo != null) {
      maps = await db.query("selecao", where: "ativo = 1", orderBy: "nome");
    }
    else {
      maps = await db.query("selecao", orderBy: "nome");
    }

    return List.generate(maps.length, (i) {
      return Selecao(
        id: maps[i]['id'],
        ativo: maps[i]['ativo'] == 1 ? true : false,
        nome: maps[i]['nome']
      );
    });
  }

  Future<Selecao> getSelecaoById(int id) async {
    final Database db = await sqlite.database;
    Selecao selecao;

    final List<Map<String, dynamic>> maps = await db.query("selecao", where: "id = ?", whereArgs: [id]);

    if(maps.isNotEmpty) {
      selecao = Selecao(
        id: maps[0]['id'],
        ativo: maps[0]['ativo'] == 1 ? true : false,
        nome: maps[0]['nome']
      );
    }

    return selecao;
  }

  Future<void> insertSelecao(Selecao selecao) async {
    final Database db = await sqlite.database;

    await db.insert(
      'selecao',
      selecao.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateSelecao(Selecao selecao) async {
    final Database db = await sqlite.database;

    await db.update(
        'selecao',
        selecao.toMap(),
        where: "id = ?",
        whereArgs: [selecao.id]
    );
  }

  Future<void> deleteSelecao(int id) async {
    final db = await sqlite.database;

    await db.delete(
      'selecao',
      where: "id = ?",
      whereArgs: [id],
    );
  }
}