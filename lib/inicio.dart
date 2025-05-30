import 'package:flutter/material.dart';

class InicioPage extends StatefulWidget {
  const InicioPage({super.key});

  @override
  State<InicioPage> createState() => _InicioPageState();
}

class _InicioPageState extends State<InicioPage> {
  final List<Map<String, dynamic>> _tarefas = [
    {
      "nome": "Estudar Flutter",
      "dataCriacao": "2024-06-01",
      "descricao":
          "At vero eos et accusamus et iusto odio dignissimos ducimus qui blanditiis praesentium voluptatum deleniti atque corrupti quos dolores et quas molestias excepturi sint occaecati cupiditate non provident, similique sunt in culpa qui officia deserunt mollitia animi, id est laborum et dolorum fuga. Et harum quidem rerum facilis est et expedita distinctio. Nam libero tempore, cum soluta nobis est eligendi optio cumque nihil impedit quo minus id quod maxime placeat facere possimus, omnis voluptas assumenda est, omnis dolor repellendus. Temporibus autem quibusdam et aut officiis debitis aut rerum necessitatibus saepe eveniet ut et voluptates repudiandae sint et molestiae non recusandae. Itaque earum rerum hic tenetur a sapiente delectus, ut aut reiciendis voluptatibus maiores alias consequatur aut perferendis doloribus asperiores repellat. ",
      "status": "Concluído",
    },
    {
      "nome": "Revisar Dart",
      "dataCriacao": "2024-06-02",
      "descricao": "Praticar conceitos básicos e avançados de Dart.",
      "status": "Pendente",
    },
    {
      "nome": "Implementar Login",
      "dataCriacao": "2024-06-03",
      "descricao": "Criar tela de login para o app.",
      "status": "Concluído",
    },
  ];

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
                      "Olá [NOME USUÁRIO]",
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
                      "Altuma tarefa nova?",
                      style: TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 40),
                    CriadorTarefas(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Lista de tarefas
            SliverList(
              delegate: SliverChildBuilderDelegate((context, index) {
                final tarefa = _tarefas[index];
                return _TarefaItem(
                  titulo: tarefa['nome'],
                  descricao: tarefa['descricao'],
                  data: tarefa['dataCriacao'],
                  status: tarefa['status'],
                  onPressed: () {
                    // Ação ao clicar na tarefa
                  },
                );
              }, childCount: _tarefas.length),
            ),
          ],
        ),
      ),
    );
  }

  void _adicionarTarefa() {
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

class CriadorTarefas extends StatelessWidget {
  const CriadorTarefas({super.key});

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
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Nome da Tarefa",
                    style: TextStyle(color: Colors.purple),
                  ),
                  SizedBox(height: 5),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.calendar_month,
                        size: 28,
                        color: Colors.purple,
                      ),
                      SizedBox(width: 5),
                      SizedBox(
                        width: 190,
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Digite aqui",
                            border: UnderlineInputBorder(),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  Text(
                    "Descrição da Tarefa",
                    style: TextStyle(color: Colors.purple),
                  ),
                  SizedBox(height: 5),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.description_outlined,
                        size: 28,
                        color: Colors.purple,
                      ),
                      SizedBox(width: 5),
                      SizedBox(
                        width: 190,
                        child: TextField(
                          decoration: InputDecoration(
                            hintText: "Digite aqui",
                            border: UnderlineInputBorder(),
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 8),
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 15),
                  ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.purple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 0,
                      ),
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
              SizedBox(width: 2.3),
              Image.asset(
                'assets/Logo.png',
                width: 120,
                height: 120,
                fit: BoxFit.cover,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _TarefaItem extends StatelessWidget {
  final String titulo;
  final String descricao;
  final String data;
  final String status;
  final VoidCallback onPressed;

  const _TarefaItem({
    required this.titulo,
    required this.descricao,
    required this.data,
    required this.status,
    required this.onPressed,
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
                        onPressed: onPressed,
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
