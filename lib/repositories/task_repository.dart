import 'dart:convert';
import 'package:http/http.dart' as http;

class TarefaRepository {
  final String baseUrl = "http://localhost:3000/tasks";

  ///  Buscar todas as tarefas
  Future<List<Map<String, dynamic>>> buscarTarefas() async {
    final url = Uri.parse(baseUrl);
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization":
            "Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE3NDg3MjM4MzYsImV4cCI6MTc0ODgxMDIzNiwic3ViIjoiMSJ9.bfFm25rPt-4_Jn7G-bZ81hnBW15OSDmnUuGQ2-aGanY",
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonData = jsonDecode(response.body);
      return jsonData
          .map(
            (tarefa) => {
              "id": tarefa["id"],
              "nome": tarefa["title"],
              "descricao": tarefa["description"],
              "status": tarefa["status"],
              "dataCriacao": tarefa["createdAt"],
            },
          )
          .toList();
    } else {
      throw Exception("Erro ao carregar tarefas: ${response.statusCode}");
    }
  }

  /// Criar uma nova tarefa
  Future<void> criarTarefa(String titulo, String descricao) async {
    final url = Uri.parse(baseUrl);

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE3NDg3MjM4MzYsImV4cCI6MTc0ODgxMDIzNiwic3ViIjoiMSJ9.bfFm25rPt-4_Jn7G-bZ81hnBW15OSDmnUuGQ2-aGanY',
      },
      body: jsonEncode({
        'title': titulo,
        'description': descricao,
        'status': 'Pendente',
        'createdAt': DateTime.now().toIso8601String(),
      }),
    );

    if (response.statusCode == 201) {
      print("Tarefa criada com sucesso!");
    } else {
      throw Exception("Erro ao criar tarefa: ${response.statusCode}");
    }
  }

  ///  Atualizar uma tarefa existente
  Future<void> atualizarTarefa(int id, String titulo, String descricao) async {
    final url = Uri.parse("$baseUrl/$id");

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpYXQiOjE3NDg3MjM4MzYsImV4cCI6MTc0ODgxMDIzNiwic3ViIjoiMSJ9.bfFm25rPt-4_Jn7G-bZ81hnBW15OSDmnUuGQ2-aGanY',
      },
      body: jsonEncode({
        'title': titulo,
        'description': descricao,
        'status': 'Pendente',
        'createdAt': DateTime.now().toIso8601String(),
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 204) {
      print("Tarefa atualizada com sucesso!");
    } else {
      throw Exception("Erro ao atualizar tarefa: ${response.statusCode}");
    }
  }
}
