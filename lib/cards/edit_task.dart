import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EditTaskModal extends StatefulWidget {
  final Map<String, dynamic> task;
  final VoidCallback onTaskUpdated;

  EditTaskModal({required this.task, required this.onTaskUpdated});

  @override
  _EditTaskModalState createState() => _EditTaskModalState();
}

class _EditTaskModalState extends State<EditTaskModal> {
  late TextEditingController _nameController;
  late TextEditingController _descriptionController;
  late String taskStatus;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.task['nome']);
    _descriptionController = TextEditingController(
      text: widget.task['descricao'],
    );
    taskStatus = widget.task['status'];
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Future<void> _updateTask() async {
    final url = Uri.parse("http://localhost:3000/tasks/${widget.task['id']}");

    final response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization":
            "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE3NDg3MjM4MzYsImV4cCI6MTc0ODgxMDIzNiwic3ViIjoiMSJ9.bfFm25rPt-4_Jn7G-bZ81hnBW15OSDmnUuGQ2-aGanY",
      },
      body: jsonEncode({
        "title": _nameController.text, // Nome atualizado da tarefa
        "description": _descriptionController.text, // Nova descrição
        "status": taskStatus, // Status atualizado
      }),
    );

    if (response.statusCode == 200) {
      widget
          .onTaskUpdated(); // Chama a função fetchTasks() na tela inicial para atualizar a lista
      Navigator.pop(context); // Fecha o modal
    } else {
      print("Erro ao atualizar tarefa: ${response.statusCode}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      backgroundColor: Colors.black87,
      child: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Editar Tarefa",
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: _nameController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Nome da Tarefa",
                labelStyle: TextStyle(color: Colors.white),
              ),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _descriptionController,
              style: TextStyle(color: Colors.white),
              decoration: InputDecoration(
                labelText: "Descrição",
                labelStyle: TextStyle(color: Colors.white),
              ),
              maxLines: 3,
            ),
            SizedBox(height: 15),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ChoiceChip(
                  label: Text("Concluída"),
                  selected: taskStatus == "Concluída",
                  onSelected:
                      (selected) => setState(() => taskStatus = "Concluída"),
                ),
                SizedBox(width: 10),
                ChoiceChip(
                  label: Text("Pendente"),
                  selected: taskStatus == "Pendente",
                  onSelected:
                      (selected) => setState(() => taskStatus = "Pendente"),
                ),
              ],
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: Text(
                    "Cancelar",
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                ElevatedButton(onPressed: _updateTask, child: Text("Salvar")),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
