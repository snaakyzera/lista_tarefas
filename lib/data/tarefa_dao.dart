import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../models/tarefa_model.dart';

class TarefaDao {
  static const String _nomeBanco = 'lista_tarefas.db';
  static const String tabela = 'tarefas';

  Database? _db;

  Future<Database> _abrir() async {
    if (_db != null) return _db!;
    final caminho = p.join(await getDatabasesPath(), _nomeBanco);
    _db = await openDatabase(
      caminho,
      version: 1,
      onCreate: _criarTabela,
    );
    return _db!;
  }

  Future<void> _criarTabela(Database db, int versao) async {
    await db.execute('''
      CREATE TABLE $tabela (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT NOT NULL,
        concluida INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  Future<void> salvar(TarefaModel tarefa) async {
    final db = await _abrir();
    await db.insert(tabela, tarefa.toMap());
  }

  Future<List<TarefaModel>> buscarTodas() async {
    final db = await _abrir();
    final resultado = await db.query(tabela, orderBy: 'id');
    return resultado.map(TarefaModel.fromMap).toList();
  }

  Future<void> alternarConcluida(TarefaModel tarefa) async {
    final db = await _abrir();
    await db.update(
      tabela,
      {'concluida': tarefa.concluida ? 0 : 1},
      where: 'id = ?',
      whereArgs: [tarefa.id],
    );
  }

  Future<void> remover(int id) async {
    final db = await _abrir();
    await db.delete(tabela, where: 'id = ?', whereArgs: [id]);
  }
}
