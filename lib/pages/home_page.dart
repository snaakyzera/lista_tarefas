import 'package:flutter/material.dart';

import '../data/tarefa_dao.dart';
import '../models/tarefa_model.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final TarefaDao _dao = TarefaDao();
  final TextEditingController _tituloController = TextEditingController();

  late Future<List<TarefaModel>> _futureTarefas;

  @override
  void initState() {
    super.initState();
    _futureTarefas = _dao.buscarTodas();
  }

  @override
  void dispose() {
    _tituloController.dispose();
    super.dispose();
  }

  void _atualizarLista() {
    if (!mounted) return;
    setState(() {
      _futureTarefas = _dao.buscarTodas();
    });
  }

  Future<void> _salvarTarefa() async {
    final texto = _tituloController.text.trim();
    if (texto.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Escreva uma tarefa primeiro.')),
      );
      return;
    }
    await _dao.salvar(TarefaModel(titulo: texto));
    _tituloController.clear();
    _atualizarLista();
  }


  Future<void> _alternar(TarefaModel tarefa) async {
    await _dao.alternarConcluida(tarefa);
    _atualizarLista();
  }


  Future<void> _confirmarExclusao(TarefaModel tarefa) async {
    final confirmou = await showDialog<bool>(
      context: context,
      builder: (contextoDialogo) => AlertDialog(
        title: const Text('Excluir tarefa?'),
        content: Text('A tarefa “${tarefa.titulo}” será apagada.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(contextoDialogo, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(contextoDialogo, true),
            child: const Text('Excluir'),
          ),
        ],
      ),
    );

    if (confirmou == true) {
      await _dao.remover(tarefa.id!);
      _atualizarLista();
    }
  }

  @override
  Widget build(BuildContext context) {
    final cores = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Minhas Tarefas'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: FutureBuilder<List<TarefaModel>>(
                future: _futureTarefas,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Center(
                      child: Text('Não foi possível ler o banco: ${snapshot.error}'),
                    );
                  }
                  if (!snapshot.hasData) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  final lista = snapshot.data!;
                  if (lista.isEmpty) {
                    return const _ListaVazia();
                  }

                  final pendentes = lista.where((t) => !t.concluida).length;

                  return Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
                        child: Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            pendentes == 0
                                ? 'Tudo concluído'
                                : 'Faltam $pendentes de ${lista.length}',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                        ),
                      ),
                      Expanded(
                        child: ListView.separated(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                          itemCount: lista.length,
                          separatorBuilder: (context, index) => const SizedBox(height: 6),
                          itemBuilder: (context, index) {
                            final tarefa = lista[index];
                            return Card(
                              clipBehavior: Clip.antiAlias,
                              child: CheckboxListTile(
                                value: tarefa.concluida,
                                onChanged: (_) => _alternar(tarefa),
                                controlAffinity: ListTileControlAffinity.leading,
                                title: Text(
                                  tarefa.titulo,
                                  style: TextStyle(
                                    decoration: tarefa.concluida
                                        ? TextDecoration.lineThrough
                                        : TextDecoration.none,
                                    color: tarefa.concluida ? cores.outline : null,
                                  ),
                                ),
                                secondary: IconButton(
                                  icon: const Icon(Icons.delete),
                                  color: cores.error,
                                  tooltip: 'Excluir',
                                  onPressed: () => _confirmarExclusao(tarefa),
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),

            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _tituloController,
                      textCapitalization: TextCapitalization.sentences,
                      textInputAction: TextInputAction.send,
                      onSubmitted: (_) => _salvarTarefa(),
                      decoration: InputDecoration(
                        hintText: 'O que você precisa fazer?',
                        filled: true,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 20),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton.filled(
                    onPressed: _salvarTarefa,
                    icon: const Icon(Icons.add),
                    tooltip: 'Adicionar tarefa',
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ListaVazia extends StatelessWidget {
  const _ListaVazia();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.checklist_rounded,
              size: 64,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(height: 12),
            const Text(
              'Nenhuma tarefa por aqui',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 4),
            const Text('Escreva no campo abaixo para começar.'),
          ],
        ),
      ),
    );
  }
}
