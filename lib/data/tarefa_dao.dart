import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

import '../models/tarefa_model.dart';

// DAO = Data Access Object.
// É a única parte do app que conversa com o SQLite.
class TarefaDao {
  static const String _nomeBanco = 'lista_tarefas.db';
  static const String tabela = 'tarefas';

  Database? _db;

  // Abre o banco na primeira chamada e reaproveita nas próximas.
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

  // [1] CRIAÇÃO DA TABELA tarefas (id, titulo, concluida)
  // Roda uma vez só, quando o arquivo do banco ainda não existe.
  Future<void> _criarTabela(Database db, int versao) async {
    await db.execute('''
      CREATE TABLE $tabela (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT NOT NULL,
        concluida INTEGER NOT NULL DEFAULT 0
      )
    ''');
  }

  // [2] INSERT: grava uma tarefa nova.
  Future<void> salvar(TarefaModel tarefa) async {
    final db = await _abrir();
    await db.insert(tabela, tarefa.toMap());
  }

  // [3] SELECT: devolve todas as tarefas, na ordem em que foram criadas.
  Future<List<TarefaModel>> buscarTodas() async {
    final db = await _abrir();
    final resultado = await db.query(tabela, orderBy: 'id');
    return resultado.map(TarefaModel.fromMap).toList();
  }

  // [4] UPDATE: troca concluida de 0 para 1 ou de 1 para 0.
  Future<void> alternarConcluida(TarefaModel tarefa) async {
    final db = await _abrir();
    await db.update(
      tabela,
      {'concluida': tarefa.concluida ? 0 : 1},
      where: 'id = ?',
      whereArgs: [tarefa.id],
    );
  }

  // [4] DELETE: apaga a tarefa pelo id.
  Future<void> remover(int id) async {
    final db = await _abrir();
    await db.delete(tabela, where: 'id = ?', whereArgs: [id]);
  }
}
