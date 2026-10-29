// Representa uma linha da tabela "tarefas".
class TarefaModel {
  final int? id;
  final String titulo;
  final bool concluida;

  TarefaModel({
    this.id,
    required this.titulo,
    this.concluida = false,
  });

  // Lê uma linha que veio do banco e transforma em objeto.
  // No SQLite, concluida fica salva como 0 (não) ou 1 (sim).
  factory TarefaModel.fromMap(Map<String, Object?> mapa) {
    return TarefaModel(
      id: mapa['id'] as int?,
      titulo: mapa['titulo'] as String,
      concluida: (mapa['concluida'] as int) == 1,
    );
  }

  // Transforma o objeto em Map para gravar no banco.
  // O id só entra se existir; numa tarefa nova o banco gera sozinho.
  Map<String, Object?> toMap() {
    return {
      if (id != null) 'id': id,
      'titulo': titulo,
      'concluida': concluida ? 1 : 0,
    };
  }
}
