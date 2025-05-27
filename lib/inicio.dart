import 'package:flutter/material.dart';

const List<Map<String, dynamic>> tarefas = [
  {
    "nome": "Estudar Flutter",
    "dataCriacao": "2024-06-01",
    "descricao": "Ler a documentação oficial do Flutter.",
    "status": "Pendente",
  },
  {
    "nome": "Revisar Dart",
    "dataCriacao": "2024-06-02",
    "descricao": "Praticar conceitos básicos e avançados de Dart.",
    "status": "Em andamento",
  },
  {
    "nome": "Implementar Login",
    "dataCriacao": "2024-06-03",
    "descricao": "Criar tela de login para o app.",
    "status": "Concluído",
  },
  {
    "nome": "Criar Lista de Tarefas",
    "dataCriacao": "2024-06-04",
    "descricao": "Desenvolver componente para exibir tarefas.",
    "status": "Pendente",
  },
  {
    "nome": "Testar Aplicativo",
    "dataCriacao": "2024-06-05",
    "descricao": "Executar testes unitários e de integração.",
    "status": "Pendente",
  },
  {
    "nome": "Ajustar Layout",
    "dataCriacao": "2024-06-06",
    "descricao": "Melhorar responsividade das telas.",
    "status": "Em andamento",
  },
  {
    "nome": "Adicionar Splash Screen",
    "dataCriacao": "2024-06-07",
    "descricao": "Criar tela inicial animada.",
    "status": "Pendente",
  },
  {
    "nome": "Configurar Navegação",
    "dataCriacao": "2024-06-08",
    "descricao": "Implementar rotas entre páginas.",
    "status": "Concluído",
  },
  {
    "nome": "Documentar Código",
    "dataCriacao": "2024-06-09",
    "descricao": "Adicionar comentários e documentação.",
    "status": "Pendente",
  },
  {
    "nome": "Publicar no GitHub",
    "dataCriacao": "2024-06-10",
    "descricao": "Subir projeto para repositório remoto.",
    "status": "Pendente",
  },
];

class InicioPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Minhas Tarefas"),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Adicione aqui a lógica de logout se necessário
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(
              height: 128,
              width: 128,
              child: Image.asset('assets/atria.jpeg'),
            ),
            SizedBox(height: 20),
            BotoesCriarEditar(),
            ListaTarefas(),
          ],
        ),
      ),
    );
  }
}

final Function criarTarefa = () {
  print('Função criarTarefa chamada');
};

class BotoesCriarEditar extends StatelessWidget {
  const BotoesCriarEditar({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      height: 80,
      child: Row(
        children: [
          SizedBox(width: 8),
          ElevatedButton(
            onPressed: criarTarefa(),
            child: const Row(
              children: [
                SizedBox(width: 20),
                Text("Criar"),
                SizedBox(width: 4),
                Icon(Icons.add),
                SizedBox(width: 16),
              ],
            ),
          ),
          SizedBox(width: 10),
          ElevatedButton(
            onPressed: criarTarefa(),
            child: const Row(
              children: [
                SizedBox(width: 20),
                Text("Editar"),
                SizedBox(width: 4),
                Icon(Icons.edit),
                SizedBox(width: 16),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ListaTarefas extends StatelessWidget {
  const ListaTarefas({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 640, // Defina a altura conforme necessário
      child: SingleChildScrollView(
        child: Column(
          children:
              tarefas
                  .map(
                    (tarefa) => Tarefa(
                      titulo: tarefa['nome'],
                      descricao: tarefa['descricao'],
                      dataCriacao: tarefa['dataCriacao'],
                      estado: tarefa['status'],
                    ),
                  )
                  .toList(),
        ),
      ),
    );
  }
}

class Tarefa extends StatefulWidget {
  final String titulo;
  final String descricao;
  final String dataCriacao;
  final String estado;

  const Tarefa({
    super.key,
    required this.titulo,
    required this.descricao,
    required this.dataCriacao,
    required this.estado,
  });

  @override
  State<Tarefa> createState() => _TarefaState();
}

class _TarefaState extends State<Tarefa> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      margin: const EdgeInsets.symmetric(vertical: 6),
      decoration: BoxDecoration(
        color: Colors.purple[100],
        borderRadius: BorderRadius.circular(12),
      ),
      width: MediaQuery.of(context).size.width * 0.75,
      height: 56,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(Icons.keyboard_arrow_down_rounded),
              SizedBox(
                width: 120,
                child: Text(
                  widget.titulo,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
          SizedBox(
            width: 100,
            child: Text(
              widget.estado,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
              textAlign: TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }
}
