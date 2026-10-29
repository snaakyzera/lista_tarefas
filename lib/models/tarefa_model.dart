
class TarefaModel {
  final int? id;
  final String titulo;
  final bool concluida;

  TarefaModel({
    this.id,
    required this.titulo,
    this.concluida = false,
  });

  factory TarefaModel.fromMap(Map<String, Object?> mapa) {
    return TarefaModel(
      id: mapa['id'] as int?,
      titulo: mapa['titulo'] as String,
      concluida: (mapa['concluida'] as int) == 1,
    );
  }

  Map<String, Object?> toMap() {
    return {
      if (id != null) 'id': id,
      'titulo': titulo,
      'concluida': concluida ? 1 : 0,
    };
  }
}
