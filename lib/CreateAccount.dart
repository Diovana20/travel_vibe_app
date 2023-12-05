import 'package:flutter/material.dart';
import 'Login.dart';
import 'model/Usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class CreateAccount extends StatefulWidget {
  const CreateAccount({super.key});

  @override
  State<CreateAccount> createState() => _CreateAccountState();
}

class _CreateAccountState extends State<CreateAccount> {
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  TextEditingController _controllerNome = TextEditingController();
  TextEditingController _controllerEmail = TextEditingController();
  TextEditingController _controllerSenha = TextEditingController();
  String _mensagemErro = "";

  _validarCampos() {
    String nome = _controllerNome.text;
    String email = _controllerEmail.text;
    String senha = _controllerSenha.text;

    if (nome.isNotEmpty) {
      if (email.isNotEmpty && email.contains("@")) {
        if (senha.isNotEmpty && senha.length > 6) {
          setState(() {
            _mensagemErro = "";
          });

          Usuario usuario = Usuario();
          usuario.nome = nome;
          usuario.email = email;
          usuario.senha = senha;
          _cadastrarUsuario(usuario);
        } else {
          SnackBar snackBar = SnackBar(
            backgroundColor: Colors.red,
            content: Text("Preencha a senha! Digite mais de 6 caracteres"),
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
    } else {
      SnackBar snackBar = SnackBar(
        backgroundColor: Colors.red,
        content: Text("Preencha o Nome"),
      );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
_cadastrarUsuario(Usuario usuario) async {
    FirebaseAuth auth = FirebaseAuth.instance;
    
    try {
      UserCredential userCredential = await auth.createUserWithEmailAndPassword(
        email: usuario.email.toString(), 
        password: usuario.senha.toString(),
    );

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    await firestore
      .collection("users")
      .doc(userCredential.user?.uid)
      .set(usuario.toMap());

    Navigator.pushReplacement(
      context, MaterialPageRoute(builder: (context) => Login()));
    } catch (e) {
      SnackBar snackBar = SnackBar(
        backgroundColor: Colors.red,
        content: Text(
            "Erro ao cadastrar usuário, verique os campos e tente novamente!"),
      );
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    };
  }
  @override
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
                   Padding(
                    padding: EdgeInsets.only(top: 5, bottom: 3),
                    child: TextField(
                      controller: _controllerNome,
                      decoration: InputDecoration(
                        hintText: 'Nome',
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
                   ),
                    
                    Padding(
                    padding: EdgeInsets.only(top: 5, bottom: 5),
                    child: 
                    TextField(
                      controller: _controllerEmail,
                      decoration: InputDecoration(
                        hintText: 'E-mail',
                        prefixIcon: Icon(Icons.email),
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
                  ),
                    
                    Padding(
                      padding: EdgeInsets.only(top: 5, bottom: 5),
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
                    Padding(
                      padding: EdgeInsets.only(top: 5, bottom: 50),
                      child: TextField(
                        obscureText: true,
                        decoration: InputDecoration(
                        hintText: 'Confirmar senha',
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
                        if(_cadastrarUsuario == true){
                          Navigator.pushReplacement(
                        context, 
                        MaterialPageRoute(builder: (context) => Login()));
                        }
                      },
                      child: Center(
                      child: Text(
                        textAlign: TextAlign.center,
                        "Criar conta",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          
                        ),
                      ),
                      ),
                    ),
                    ),
                    Container(height: 8,
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => Login()),
                        );
                      },
                      child: Text(
                        "Já possui uma conta? Entre aqui",
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