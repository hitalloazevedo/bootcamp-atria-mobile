import 'package:flutter/material.dart';

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
