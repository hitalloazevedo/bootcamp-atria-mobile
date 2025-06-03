import 'package:flutter/material.dart';
import 'package:teste_flutter/inicio.dart';
import 'package:http/http.dart' as http;
import 'package:teste_flutter/repositories/auth_repository.dart';

//parte de registrar um usuário
class RegisterPage extends StatefulWidget {
  // Nome da classe com UpperCamelCase
  const RegisterPage({super.key}); // Construtor com const e key

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

// Classe State
class _RegisterPageState extends State<RegisterPage> {
  // Controllers e outras variáveis de estado
  final TextEditingController _emailRegisterController =
      TextEditingController();
  final TextEditingController _passwordRegisterController =
      TextEditingController();
  final TextEditingController _passwordRegisterConfirmController =
      TextEditingController();
  final TextEditingController _nomeRegisterController = TextEditingController();

  final AuthRepository _authRepository = AuthRepository();
  bool _isLoading = false;

  // Método dispose para limpar os controllers
  @override
  void dispose() {
    _emailRegisterController.dispose();
    _passwordRegisterController.dispose();
    _passwordRegisterConfirmController.dispose();
    _nomeRegisterController.dispose();
    super.dispose();
  }

  //função de verificação e chamada da API
  Future<void> verificarRegister() async {
    String emailRegister = _emailRegisterController.text;
    String passwordRegister = _passwordRegisterController.text;
    String passwordRegisterConfirm = _passwordRegisterConfirmController.text;
    String nomeRegister = _nomeRegisterController.text;

    if (passwordRegister.length < 2 ||
        emailRegister.length < 8 ||
        passwordRegisterConfirm.length < 2) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos!')),
      );

      return;
    }

    if (passwordRegisterConfirm != passwordRegister) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('As duas senhas devem ser iguais!')),
      );

      return;
    }

    // Se passou nas validações locais
    setState(() {
      _isLoading = true;
    });

    // Chama o método do AuthRepository
    String? errorMessage;
    try {
      final response = await http.post(
        Uri.parse('http://10.0.2.2:3000/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: '{"name": "$nomeRegister", "email": "$emailRegister", "password": "$passwordRegister"}',
      );

      if (response.statusCode < 300) {
        errorMessage = null;
      } else {
        errorMessage = 'Erro ao registrar usuário: ${response.body}';
      }
    } catch (e) {
      errorMessage = 'Erro de conexão: $e';
    }

    // É importante checar 'mounted' novamente após uma operação 'await'
    if (!mounted) return;

    if (errorMessage == null) {
      // Sucesso!
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Usuário registrado com sucesso! Por favor, faça o login.',
          ),
          backgroundColor: Colors.green,
        ),
      );

      // Limpar campos
      _nomeRegisterController.clear();
      _emailRegisterController.clear();
      _passwordRegisterController.clear();
      _passwordRegisterConfirmController.clear();

      Navigator.pop(context);
    } else {
      // Erro! A mensagem de erro veio do AuthRepository
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage), backgroundColor: Colors.red),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Cadastro")), // Adicionado const
      body: Container(
        color: Colors.white,
        padding: const EdgeInsets.only(
          top: 60,
          left: 40,
          right: 40,
        ), // Adicionado const
        child: ListView(
          children: [
            SizedBox(
              height: 128,
              width: 128,
              child: Image.asset(
                'assets/Logo.png',
              ), // Certifique-se que 'assets/Logo.png' está no pubspec.yaml
            ),
            const SizedBox(height: 40), // Adicionado const
            TextFormField(
              // autofocus: true, // Geralmente, evite múltiplos autofocus
              controller:
                  _nomeRegisterController, // Usa o controller da classe State
              keyboardType: TextInputType.name, // Mais apropriado para nome
              decoration: const InputDecoration(
                // Adicionado const
                labelText: "Nome",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                ),
              ),
              style: const TextStyle(fontSize: 15), // Adicionado const
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller:
                  _emailRegisterController, // Usa o controller da classe State
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                // Adicionado const
                labelText: "E-mail",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                ),
              ),
              style: const TextStyle(fontSize: 15), // Adicionado const
            ),
            const SizedBox(height: 16),
            TextFormField(
              obscureText: true,
              controller:
                  _passwordRegisterController, // Usa o controller da classe State
              decoration: const InputDecoration(
                // Adicionado const
                labelText: "Senha",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                ),
              ),
              style: const TextStyle(fontSize: 15), // Adicionado const
            ),
            const SizedBox(height: 16),
            TextFormField(
              obscureText: true,
              controller:
                  _passwordRegisterConfirmController, // Usa o controller da classe State
              decoration: const InputDecoration(
                // Adicionado const
                labelText: "Confirmar Senha",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                ),
              ),
              style: const TextStyle(fontSize: 15), // Adicionado const
            ),
            const SizedBox(height: 40),
            Container(
              height: 60,
              alignment: Alignment.centerLeft,
              decoration: const BoxDecoration(
                // Adicionado const
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.3, 1],
                  colors: [Color(0xFF7F00FF), Color(0xFFE100FF)],
                ),
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: SizedBox.expand(
                child: TextButton(
                  onPressed:
                      _isLoading
                          ? null
                          : verificarRegister, // Chama o método da classe State
                  child:
                      _isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                // Adicionado const
                                "Cadastrar",
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontSize: 20,
                                ),
                                textAlign: TextAlign.left,
                              ),
                              SizedBox(
                                height: 32,
                                width: 32,
                                child: Image.asset(
                                  "assets/foguete.png",
                                ), // Certifique-se que 'assets/foguete.png' está no pubspec.yaml
                              ),
                            ],
                          ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//página de login
class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final AuthRepository _authRepository = AuthRepository();
  void verifyLogin() async {
    String passwordController = _passwordController.text;
    String emailController = _emailController.text;

    if (passwordController.length < 2 || emailController.length < 8) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos!')),
      );
    }

    setState(() {
    });

    final response = await http.post(
      Uri.parse('http://10.0.2.2:3000/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: '{"email": "$emailController", "password": "$passwordController"}',
    );

    Map<String, dynamic> result;
    if (response.statusCode < 300) {
      result = {'success': true};
    } else {
      result = {
      'success': false,
      'error': 'Erro ao fazer login: ${response.body}'
      };
    }

    if (result['success'] == true) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => const InicioPage()),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result['error'] ?? 'Erro desconhecido no login.'),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() {
    });
  }

  void usuallyRegister() {}

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Scaffold permite um appBar, uma barra em cima da aplicação e um body para o app.
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 60, left: 40, right: 40),
        color: Colors.white,
        child: ListView(
          children: [
            SizedBox(
              width: 128,
              height: 128,
              child: Image.asset("assets/Logo.png"),
            ),
            SizedBox(height: 10),
            TextFormField(
              autofocus: true,
              keyboardType: TextInputType.emailAddress,
              controller: _emailController,
              decoration: InputDecoration(
                labelText: "E-mail",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
              style: TextStyle(fontSize: 20),
            ),
            TextFormField(
              autofocus: true,
              controller: _passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Senha",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 20,
                ),
              ),
              style: TextStyle(fontSize: 20),
            ),
            Container(
              height: 40,
              alignment: Alignment.centerRight,
              child: TextButton(
                child: Text("Não tem cadastro? Cadastre-se."),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => RegisterPage()),
                  );
                },
              ),
            ),
            SizedBox(height: 40),
            Container(
              height: 60,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  stops: [0.3, 1],
                  colors: [Color(0xFF7F00FF), Color(0xFFE100FF)],
                ),
                borderRadius: BorderRadius.all(Radius.circular(5)),
              ),
              child: SizedBox.expand(
                child: TextButton(
                  onPressed: verifyLogin,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Login",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontSize: 20,
                        ),
                        textAlign: TextAlign.left,
                      ),
                      SizedBox(
                        height: 32,
                        width: 32,
                        child: Image.asset("assets/foguete.png"),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
