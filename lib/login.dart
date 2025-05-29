import 'package:flutter/material.dart';


class registerPage extends StatelessWidget{
  
  final TextEditingController _emailRegister = TextEditingController();
  final TextEditingController _passwordRegister = TextEditingController();
  final TextEditingController _passwordRegister_Confirm = TextEditingController();

  void verifyRegister(BuildContext context){

    String emailRegister = _emailRegister.text;
    String passwordRegister = _passwordRegister.text;
    String passwordRegister_Confirm = _passwordRegister_Confirm.text;


    if (passwordRegister.length < 2 || emailRegister.length < 8 || passwordRegister_Confirm.length < 2){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos!')
        ),
      );
    }

    if (passwordRegister_Confirm != passwordRegister){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('As duas senhas tem que ser iguais!')
        ),
      );
    }
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(title: Text("Cadastro")),
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.only(
          top: 60,
          left: 40,
          right: 40,
        ),
        //Para o teclado não ficar em cima da foto e dos inputs
        child: ListView(
          children: [
            SizedBox(
              height: 128,
              width: 128,
              child: Image.asset('assets/atria.jpeg'),
            ),
            SizedBox(
              height: 40,
            ),
            TextFormField(
              autofocus: true,
              controller: _emailRegister,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "E-mail",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                ),
              ),
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              autofocus: true,
              obscureText: true,
              controller: _passwordRegister,
              decoration: InputDecoration(
                labelText: "Senha",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                ),
              ), 
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              autofocus: true,
              obscureText: true,
              controller: _passwordRegister_Confirm,
              decoration: InputDecoration(
                labelText: "Confirmar Senha",
                labelStyle: TextStyle(
                  color: Colors.black38,
                  fontWeight: FontWeight.w400,
                  fontSize: 15,
                ),
              ), 
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(
            height: 40,
          ),
          Container(
            height: 60,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.3,1],
                colors: [
                  Color(0xFF7F00FF),
                  Color(0xFFE100FF),
                ],
              ),
              borderRadius: BorderRadius.all( 
                Radius.circular(5)
              ),
            ),
            child: SizedBox.expand(
              child: TextButton(
                onPressed: () {
                  verifyRegister(context);
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
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

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();

}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void verifyLogin(){
    String passwordController = _passwordController.text;
    String emailController = _emailController.text;

    if (passwordController.length < 2 || emailController.length < 8){
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preencha todos os campos!')
        ),
      );
    }
  }

  void usuallyRegister(){


  }
  
  @override
  void dispose(){
    _passwordController.dispose();
    super.dispose();
  }
  @override 
  Widget build(BuildContext context){
    // Scaffold permite um appBar, uma barra em cima da aplicação e um body para o app.
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(
          top: 60,
          left: 40,
          right: 40,
        ),
      color: Colors.white,
      child: ListView(
        children: [
          SizedBox(
            width: 128,
            height: 128,
            child: Image.asset("assets/atria.jpeg"),
          ),
          SizedBox(
            height: 10,
          ),
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
              )
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
              )
            ),
            style: TextStyle(fontSize: 20),
          ),
          Container(
            height: 40,
            alignment: Alignment.centerRight,
            child: TextButton(
              child: Text(
                "Não tem cadastro? Cadastre-se.",
              ),
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => registerPage()),
                );
              },
            ),
          ),
          SizedBox(
            height: 40,
          ),
          Container(
            height: 60,
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                stops: [0.3,1],
                colors: [
                  Color(0xFF7F00FF),
                  Color(0xFFE100FF),
                ],
              ),
              borderRadius: BorderRadius.all( 
                Radius.circular(5)
              ),
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
        ]
      )
      ),
    );

  }
}