import 'package:flutter_test/flutter_test.dart';
import 'package:lista_tarefas/models/tarefa_model.dart';

void main() {
  group('TarefaModel', () {
    test('toMap salva concluida como 0 e não manda id em tarefa nova', () {
      final tarefa = TarefaModel(titulo: 'Comprar pão');
      final mapa = tarefa.toMap();

      expect(mapa['concluida'], 0);
      expect(mapa.containsKey('id'), false);
    });

    test('fromMap lê corretamente uma linha do banco', () {
      final tarefa = TarefaModel.fromMap({'id': 3, 'titulo': 'Ler', 'concluida': 1});

      expect(tarefa.id, 3);
      expect(tarefa.titulo, 'Ler');
      expect(tarefa.concluida, true);
    });
  });
}
