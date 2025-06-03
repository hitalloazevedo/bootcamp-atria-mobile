import 'package:flutter/material.dart';
import 'package:teste_flutter/services/task_service.dart';
import '../utils/secure_storage.dart';
import 'package:http/http.dart';

class CriadorTarefas extends StatefulWidget {
  final VoidCallback onTaskCreated; // Função para atualizar a tela

  const CriadorTarefas({super.key, required this.onTaskCreated});

  @override
  State<CriadorTarefas> createState() => _CriadorTarefasState();
}

class _CriadorTarefasState extends State<CriadorTarefas> {
  final TextEditingController nomeController = TextEditingController();
  final TextEditingController descricaoController = TextEditingController();

  @override
  void dispose() {
    nomeController.dispose();
    descricaoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Align(
          alignment: Alignment.centerLeft,
          child: Text(
            "DESEJA CRIAR UMA TAREFA?",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
        ),
        Container(
          width: double.infinity,
          margin: const EdgeInsets.only(top: 16),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.purple, width: 1),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              TextField(
                controller: nomeController,
                decoration: InputDecoration(
                  labelText: "Nome da Tarefa",
                  border: UnderlineInputBorder(),
                ),
              ),
              SizedBox(height: 15),
              TextField(
                controller: descricaoController,
                decoration: InputDecoration(
                  labelText: "Descrição da Tarefa",
                  border: UnderlineInputBorder(),
                ),
              ),
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: () async {
                  await criarTarefaHttp(
                    nomeController.text,
                    descricaoController.text,
                  );
                  widget.onTaskCreated(); // Atualiza a tela principal
                  nomeController.clear();
                  descricaoController.clear(); // Limpa os campos após a criação
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.purple,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 32, vertical: 10),
                ),
                child: Text(
                  "CRIAR TAREFA",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Future<void> criarTarefaHttp(String nome, String descricao) async {
    try {
      final storage = SecureStorage();
      final token = await storage.getToken();
      final response = await post(
      Uri.parse('http://10.0.2.2:3000/tasks'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: '{"title": "$nome", "description": "$descricao", "status": "Pendente"}',
      );

      if (response.statusCode > 300) {
      throw Exception('Erro ao criar tarefa: ${response.body}');
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Tarefa criada com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // Você pode mostrar um snackbar ou logar o erro
      debugPrint('Erro ao criar tarefa: $e');
    }
  }
}
