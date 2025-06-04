import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_floating_bottom_bar/flutter_floating_bottom_bar.dart';
import 'package:http/http.dart' as http;
import 'package:teste_flutter/components/create_task.dart';
import 'utils/secure_storage.dart';
import 'package:teste_flutter/login.dart';

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
    final token = await SecureStorage().getToken();
    if (token == null) {
      throw Exception('Token não encontrado');
    }
    final response = await http.get(
      Uri.parse('http://10.0.2.2:3000/tasks'),
      headers: {'Authorization': 'Bearer $token'},
    );
    if (response.statusCode == 200) {
      final decoded = jsonDecode(response.body);
      final List<dynamic> tarefas = decoded['data'] ?? [];
      setState(() {
        _tarefas =
            tarefas
                .map<Map<String, dynamic>>(
                  (tarefa) => {
                    'id': tarefa['id'].toString(),
                    'nome': tarefa['title'],
                    'descricao': tarefa['description'],
                    'dataCriacao':
                        tarefa['createdAt'] ?? '', // ajuste se necessário
                    'status': tarefa['status'],
                  },
                )
                .toList();
      });
    } else {
      throw Exception('Falha ao carregar tarefas');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
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
                    const SizedBox(height: 8),
                    const Text(
                      "Vamos colocar a sua rotina em dia.",
                      style: TextStyle(color: Colors.black, fontSize: 15),
                    ),
                    const Text(
                      "Alguma tarefa nova?",
                      style: TextStyle(color: Colors.black, fontSize: 15),
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
                  onPressed: () {},

                  onTaskUpdated: () async {
                    final token = await SecureStorage().getToken();
                    if (token == null) {
                      throw Exception('Token não encontrado');
                    }
                    final response = await http.get(
                      Uri.parse('http://10.0.2.2:3000/tasks'),
                      headers: {'Authorization': 'Bearer $token'},
                    );
                    if (response.statusCode == 200) {
                      final decoded = jsonDecode(response.body);
                      final List<dynamic> tarefas = decoded['data'] ?? [];
                      setState(() {
                        _tarefas =
                            tarefas
                                .map<Map<String, dynamic>>(
                                  (tarefa) => {
                                    'id': tarefa['id'].toString(),
                                    'nome': tarefa['title'],
                                    'descricao': tarefa['description'],
                                    'dataCriacao':
                                        tarefa['createdAt'] ??
                                        '', // ajuste se necessário
                                    'status': tarefa['status'],
                                  },
                                )
                                .toList();
                      });
                    } else {
                      throw Exception('Falha ao carregar tarefas');
                    }
                  },

                  tarefa: {},
                );
              }, childCount: _tarefas.length),
            ),
          ],
        ),
      ),

      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,

      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: Color(0xff85269D),

        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(60)),
        child: Icon(Icons.add, color: Colors.white, size: 30),
      ),

      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(top: BorderSide(color: Colors.purple, width: 2.0)),
        ),
        child: BottomAppBar(
          shape: CircularNotchedRectangle(),
          color: Colors.white,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [
              Icon(Icons.house, color: Color(0xff85269D), size: 30),
              LogoutButton(),
            ],
          ),
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
  final String id;
  final String titulo;
  final String descricao;
  final String data;
  final String status;
  final VoidCallback onPressed;
  final VoidCallback onTaskUpdated;

  const _TarefaItem({
    required this.tarefa,
    required this.titulo,
    required this.id,
    required this.descricao,
    required this.data,
    required this.status,
    required this.onPressed,
    required this.onTaskUpdated,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
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
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: Row(
                      children: [
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
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (context) {
                                String editedNome = titulo;
                                String editedDescricao = descricao;
                                String editedStatus = status;

                                return AlertDialog(
                                  title: const Text('Editar Tarefa'),
                                  content: SingleChildScrollView(
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        TextField(
                                          decoration: const InputDecoration(
                                            labelText: 'Nome',
                                          ),
                                          controller: TextEditingController(
                                            text: editedNome,
                                          ),
                                          onChanged:
                                              (value) => editedNome = value,
                                        ),
                                        TextField(
                                          decoration: const InputDecoration(
                                            labelText: 'Descrição',
                                          ),
                                          controller: TextEditingController(
                                            text: editedDescricao,
                                          ),
                                          onChanged:
                                              (value) =>
                                                  editedDescricao = value,
                                          maxLines: 3,
                                        ),
                                        const SizedBox(height: 16),
                                        StatefulBuilder(
                                          builder: (context, setState) {
                                            return Row(
                                              children: [
                                                Radio<String>(
                                                  value: 'Concluído',
                                                  groupValue: editedStatus,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      editedStatus = value!;
                                                    });
                                                  },
                                                ),
                                                const Text('Concluído'),
                                                Radio<String>(
                                                  value: 'Pendente',
                                                  groupValue: editedStatus,
                                                  onChanged: (value) {
                                                    setState(() {
                                                      editedStatus = value!;
                                                    });
                                                  },
                                                ),
                                                const Text('Pendente'),
                                              ],
                                            );
                                          },
                                        ),
                                      ],
                                    ),
                                  ),
                                  actions: [
                                    // Botão de excluir
                                    ElevatedButton(
                                      onPressed: () async {
                                        final token =
                                            await SecureStorage().getToken();
                                        if (token == null) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Token não encontrado',
                                              ),
                                            ),
                                          );
                                          return;
                                        }
                                        final response = await http.delete(
                                          Uri.parse(
                                            'http://10.0.2.2:3000/tasks/$id',
                                          ),
                                          headers: {
                                            'Authorization': 'Bearer $token',
                                          },
                                        );
                                        if (response.statusCode < 300) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Tarefa excluída com sucesso',
                                              ),
                                            ),
                                          );
                                          onTaskUpdated();
                                          Navigator.of(context).pop();
                                        } else {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Erro ao excluir tarefa',
                                              ),
                                            ),
                                          );
                                        }
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.purple,
                                        minimumSize: const Size(32, 32),
                                        padding: EdgeInsets.zero,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                      ),
                                      child: const Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                    TextButton(
                                      onPressed:
                                          () => Navigator.of(context).pop(),
                                      child: const Text('Cancelar'),
                                    ),
                                    ElevatedButton(
                                      onPressed: () async {
                                        // Atualiza a tarefa usando a biblioteca HTTP
                                        final token =
                                            await SecureStorage().getToken();
                                        if (token == null) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Token não encontrado',
                                              ),
                                            ),
                                          );
                                          return;
                                        }
                                        final response = await http.put(
                                          Uri.parse(
                                            'http://10.0.2.2:3000/tasks/$id',
                                          ),
                                          headers: {
                                            'Authorization': 'Bearer $token',
                                            'Content-Type': 'application/json',
                                          },
                                          body: jsonEncode({
                                            'title': editedNome,
                                            'description': editedDescricao,
                                            'status': editedStatus,
                                          }),
                                        );
                                        if (response.statusCode < 300) {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Tarefa atualizada com sucesso',
                                              ),
                                            ),
                                          );
                                        } else {
                                          ScaffoldMessenger.of(
                                            context,
                                          ).showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                'Erro ao atualizar tarefa',
                                              ),
                                            ),
                                          );
                                        }
                                        Future.delayed(Duration.zero, () {
                                          if (context.mounted) {
                                            context
                                                .findAncestorStateOfType<
                                                  _InicioPageState
                                                >()
                                                ?.fetchTasks();
                                          }
                                        });
                                        onTaskUpdated();
                                        Navigator.of(context).pop();
                                      },
                                      child: const Text('Salvar'),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                          style: ElevatedButton.styleFrom(
                            minimumSize: const Size(32, 32),
                            padding: EdgeInsets.zero,
                            shape: RoundedRectangleBorder(
                              side: BorderSide(color: Color(0xff85269D)),
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Icon(
                            Icons.menu,
                            color: Color(0xff85269D),
                            size: 20,
                          ),
                        ),
                      ],
                    ),
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
                GestureDetector(
                  onTap: () async {
                    if (status != 'Concluído') {
                      final token = await SecureStorage().getToken();
                      if (token == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Token não encontrado')),
                        );
                        return;
                      }
                      final response = await http.put(
                        Uri.parse('http://10.0.2.2:3000/tasks/$id'),
                        headers: {
                          'Authorization': 'Bearer $token',
                          'Content-Type': 'application/json',
                        },
                        body: jsonEncode({
                          'title': titulo,
                          'description': descricao,
                          'status': 'Concluído',
                        }),
                      );
                      if (response.statusCode < 300) {
                        onTaskUpdated();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Tarefa marcada como concluída'),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Erro ao atualizar tarefa'),
                          ),
                        );
                      }
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.only(right: 10),
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
                          onChanged: (_) {},
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
                ),
                // Opção "Pendente"
                GestureDetector(
                  onTap: () async {
                    if (status != 'Pendente') {
                      final token = await SecureStorage().getToken();
                      if (token == null) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Token não encontrado')),
                        );
                        return;
                      }
                      final response = await http.put(
                        Uri.parse('http://10.0.2.2:3000/tasks/$id'),
                        headers: {
                          'Authorization': 'Bearer $token',
                          'Content-Type': 'application/json',
                        },
                        body: jsonEncode({
                          'title': titulo,
                          'description': descricao,
                          'status': 'Pendente',
                        }),
                      );
                      if (response.statusCode < 300) {
                        onTaskUpdated();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Tarefa marcada como pendente'),
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Erro ao atualizar tarefa'),
                          ),
                        );
                      }
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.only(right: 10),
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
                          onChanged: (_) {},
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

class LogoutButton extends StatelessWidget {
  const LogoutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),

      child: IconButton(
        icon: Icon(Icons.logout, size: 30, color: Color(0xff85269D)),

        padding: const EdgeInsets.all(8.0),
        onPressed: () async {
          final secureStorage = SecureStorage();
          await secureStorage.deleteToken();

          if (context.mounted) {
            // Use pushNamedAndRemoveUntil para limpar a pilha de navegação completamente
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/login', // Certifique-se que esta rota está definida
              (Route<dynamic> route) => false,
            );
          }
        },
      ),
    );
  }
}
