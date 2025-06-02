import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:teste_flutter/cards/create_task.dart';
import 'package:teste_flutter/cards/edit_task.dart';
import 'package:teste_flutter/services/tarefa_service.dart';

class InicioPage extends StatefulWidget {
  const InicioPage({super.key});

  @override
  State<InicioPage> createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  List<Map<String, dynamic>> _tarefas = [];

  @override
  void initState() {
    super.initState();
    fetchTasks(); // Buscar tarefas ao iniciar
  }

  Future<void> fetchTasks() async {
    List<Map<String, dynamic>> tarefas = await TarefaService().buscarTarefas();
    setState(() {
      _tarefas = tarefas;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            // Cabeçalho
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Image.asset(
                      'assets/Logo.png',
                      width: 140,
                      height: 140,
                      fit: BoxFit.cover,
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "Olá, [NOME USUÁRIO]",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      "Vamos colocar a sua rotina em dia.",
                      style: TextStyle(color: Colors.grey),
                    ),
                    const Text(
                      "Alguma tarefa nova?",
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 40),
                    CriadorTarefas(onTaskCreated: fetchTasks),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Lista de tarefas
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                if (_tarefas.isEmpty || index >= _tarefas.length) {
                  print("Erro: Índice inválido ou lista vazia!");
                  return SizedBox(); // Retorna um widget vazio para evitar o erro
                }

                final tarefa =
                    _tarefas[index]; // Agora só acessamos se o índice for válido!

                return _TarefaItem(
                  id: tarefa['id'], // Adicionando ID da tarefa
                  titulo: tarefa['nome'],
                  descricao: tarefa['descricao'],
                  data: tarefa['dataCriacao'],
                  status: tarefa['status'],
                  onPressed: () {
                    TarefaService().atualizarTarefa(
                      tarefa['id'],
                      tarefa['nome'],
                      tarefa['descricao'],
                    );
                  },
                  tarefa: {},
                );
              }, childCount: _tarefas.length),
            ),
          ],
        ),
      ),
    );
  }

  void adicionarTarefa() {
    setState(() {
      _tarefas.add({
        "nome": "Nova Tarefa ${_tarefas.length + 1}",
        "dataCriacao": DateTime.now().toString().substring(0, 10),
        "descricao": "Descrição da nova tarefa",
        "status": "Pendente",
      });
    });
  }
}

class _TarefaItem extends StatelessWidget {
  final Map<String, dynamic> tarefa;
  final String titulo;
  final String descricao;
  final String data;
  final String status;
  final VoidCallback onPressed;

  const _TarefaItem({
    required this.tarefa,
    required this.titulo,
    required this.descricao,
    required this.data,
    required this.status,
    required this.onPressed,
    required id,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: const BorderSide(color: Colors.purple, width: 1),
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ícone de menu, título e descrição
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          TarefaService().atualizarTarefa(
                            tarefa['id'],
                            tarefa['nome'],
                            tarefa['descricao'],
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.purple,
                          minimumSize: const Size(32, 32),
                          padding: EdgeInsets.zero,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        child: const Icon(
                          Icons.menu,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      Flexible(
                        child: Text(
                          titulo.length > 25
                              ? '${titulo.substring(0, 25)}...'
                              : titulo,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Text(
                      descricao.length > 90
                          ? '${descricao.substring(0, 90)}...'
                          : descricao,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 5,
                    ),
                  ),
                ],
              ),
            ),
            // Barra vertical separadora
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 12),
              width: 2,
              height: 102,
              color: Colors.purple,
            ),
            // Botões de ação
            Column(
              children: [
                SizedBox(height: 4),

                // Opção "Concluído"
                Container(
                  decoration: BoxDecoration(
                    color:
                        status == 'Concluído'
                            ? Colors.purple
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Radio<String>(
                        value: 'Concluído',
                        groupValue: status,
                        onChanged: (value) {},
                        activeColor: Colors.white,
                        fillColor: MaterialStateProperty.resolveWith<Color>(
                          (states) =>
                              status == 'Concluído'
                                  ? Colors.white
                                  : Colors.purple,
                        ),
                      ),
                      Text(
                        'Concluído',
                        style: TextStyle(
                          color:
                              status == 'Concluído'
                                  ? Colors.white
                                  : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                // Opção "Pendente"
                Container(
                  decoration: BoxDecoration(
                    color:
                        status == 'Pendente'
                            ? Colors.purple
                            : Colors.transparent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      Radio<String>(
                        value: 'Pendente',
                        groupValue: status,
                        onChanged: (value) {},
                        activeColor: Colors.white,
                        fillColor: MaterialStateProperty.resolveWith<Color>(
                          (states) =>
                              status == 'Pendente'
                                  ? Colors.white
                                  : Colors.purple,
                        ),
                      ),
                      Text(
                        'Pendente',
                        style: TextStyle(
                          color:
                              status == 'Pendente'
                                  ? Colors.white
                                  : Colors.black,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
