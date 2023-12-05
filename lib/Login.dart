import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:travel_vibe_app/Home.dart';
import 'CreateAccount.dart';
import 'model/Usuario.dart';
import 'ButtonNavigator.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  String _mensagemErro = "";

   _validarCampos() {
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    if (email.isNotEmpty && email.contains("@")) {
      if (senha.isNotEmpty) {
        setState(() {
          _mensagemErro = "";
        });

        Usuario usuario = Usuario();
        usuario.email = email;
        usuario.senha = senha;
        _logarUsuario(usuario);
      } else {
        SnackBar snackBar = SnackBar(
          backgroundColor: Colors.red,
          content: Text("Preencha a senha!"),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } else {
      SnackBar snackBar = SnackBar(
        backgroundColor: Colors.red,
        content: Text("Preencha o E-mail utilizando @"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }

  _logarUsuario (Usuario usuario) {
    FirebaseAuth auth = FirebaseAuth.instance;

    auth.signInWithEmailAndPassword(
        email: usuario.email.toString(),
        password: usuario.senha.toString()
    ).then((firebaseUser) {

      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNavigationBarExample()));

    }).catchError((error) {
      SnackBar snackBar = SnackBar(
        backgroundColor: Colors.red,
        content: Text("E-Mail ou Senha incorreto, tente novamente!"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    });
  }

  Future _verificaUsuarioLogado () async {
    FirebaseAuth auth = FirebaseAuth.instance;
    auth.signOut();

    User? usuarioLogado = await auth.currentUser;
    if (usuarioLogado != null) {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => BottomNavigationBarExample()));
    }
  }

  @override
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.maxFinite,
        height: double.maxFinite,
        child: Stack(
          children: <Widget>[
            Image.asset(
              "images/imglogins.png",
              width: MediaQuery.of(context).size.width,
              height: 276,
            ),

            Positioned(
              top: 240,
              child:Container(
                padding: EdgeInsets.only(top: 50, left: 30, right: 30),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(45),
                  topRight: Radius.circular(45)
                  )
                ),
                child: Column(
                  children: <Widget>[
                   Padding(
                      padding: EdgeInsets.only(bottom: 10),
                    child:  Text("",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        
                      )),
                   ),
                    TextField(
                      controller: _controllerEmail,
                      decoration: InputDecoration(
                        hintText: 'E-mail',
                        prefixIcon: Icon(Icons.person),
                        contentPadding: EdgeInsets.all(20.0),
                        filled: true,
                        fillColor: Colors.transparent,
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: 16, bottom: 120),
                      child: TextField(
                        controller: _controllerSenha,
                        obscureText: true,
                        decoration: InputDecoration(
                        hintText: 'Senha',
                        prefixIcon: Icon(Icons.key_sharp),
                          focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.white),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        hintStyle: TextStyle(color: Colors.grey),
                      ),
                      ),
                    ),
                    Container(
                    width: MediaQuery.of(context).size.width,
                    height: 45,
                    decoration: BoxDecoration(
                        color: const Color.fromARGB(255, 11, 57, 95),
                        borderRadius: BorderRadius.all(
                          Radius.circular(32)
                        )
                      ),
                      child: InkWell(
                      onTap: () {
                        _validarCampos();
                        if(_logarUsuario == true){
                          Navigator.pushReplacement(
                        context, 
                        MaterialPageRoute(builder: (context) => BottomNavigationBarExampleApp()));
                        }
                        /*Navigator.pushReplacement(
                        context, 
                        MaterialPageRoute(builder: (context) => Home()));*/                     
                        },
                      child: Center(
                      child: Text(
                        textAlign: TextAlign.center,
                        "Acessar",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                        ),
                      ),
                      ),
                    ),
                      
                      /*Center(
                        child: Text( 'Acessar', 
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                      ),*/
                    ),
                    Container(height: 8,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => CreateAccount()),
                        );
                      },
                      child: Text(
                        "Ainda não tem uma conta? Clique aqui",
                        style: TextStyle(
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ],
                ),
            ) , 
            )
          ],
        ),
      )
    );
  }
}