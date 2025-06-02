import '../repositories/tarefa_repository.dart';

class TarefaService {
  final TarefaRepository _repository = TarefaRepository();

  /// 🔹 Buscar todas as tarefas
  Future<List<Map<String, dynamic>>> buscarTarefas() async {
    try {
      return await _repository.buscarTarefas();
    } catch (e) {
      print("Erro ao buscar tarefas: $e");
      return []; // Retorna uma lista vazia para evitar erro de retorno null
    }
  }

  /// 🔹 Criar uma nova tarefa
  Future<void> criarTarefa(String titulo, String descricao) async {
    try {
      await _repository.criarTarefa(titulo, descricao);
    } catch (e) {
      print("Erro ao criar tarefa: $e");
    }
  }

  /// 🔹 Atualizar uma tarefa existente
  Future<void> atualizarTarefa(int id, String titulo, String descricao) async {
    try {
      await _repository.atualizarTarefa(id, titulo, descricao);
    } catch (e) {
      print("Erro ao atualizar tarefa: $e");
    }
  }
}
