  import 'package:flutter/material.dart';
  import 'package:firebase_storage/firebase_storage.dart';
  import 'package:firebase_auth/firebase_auth.dart';
  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'dart:io';

import 'package:travel_vibe_app/Login.dart';

  class Profile extends StatefulWidget {
      const Profile({Key? key}) : super(key: key);

    @override
    _ProfileState createState() => _ProfileState();
  }

  class _ProfileState extends State<Profile> {
      final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    TextEditingController _controllerNome = TextEditingController();
    File? _imagem;
    String? _idUsuarioLogado;
  // bool _subindoImagem = false;
    String? _urlImagemRecuperada;
  /*
    Future _recuperarImagem(String origemImagem) async {
      File imagemSelecionada;
      switch( origemImagem ){
        case "camera" :
          imagemSelecionada = await ImagePicker.pickImage(source: ImageSource.camera);
          break;
        case "galeria" :
          imagemSelecionada = await ImagePicker.pickImage(source: ImageSource.gallery);
          break;
      }

      setState(() {
        _imagem = imagemSelecionada;
        if( _imagem != null ) {
          _subindoImagem = true;
          _uploadImagem();
        }
      });
    }

    Future _uploadImagem() async {
      FirebaseStorage storage = FirebaseStorage.instance;
      StorageReference pastaRaiz = storage.ref();
      StorageReference arquivo = pastaRaiz
          .child("perfil")
          .child(_idUsuarioLogado + ".jpg");

      //Upload da imagem
      StorageUploadTask task = arquivo.putFile(_imagem);

      //Controlar progresso do upload
      task.events.listen((StorageTaskEvent storageEvent){

        if ( storageEvent.type == StorageTaskEventType.progress ) {
          setState(() {
            _subindoImagem = true;
          });
        } else if( storageEvent.type == StorageTaskEventType.success ) {
          setState(() {
            _subindoImagem = false;
          });
        }
      });

      Recuperar url da imagem
      task.onComplete.then((StorageTaskSnapshot snapshot){
        _recuperarUrlImagem(snapshot);
      });
    }

    Future _recuperarUrlImagem(StorageTaskSnapshot snapshot) async {
      String url = await snapshot.ref.getDownloadURL();
      _atualizarUrlImagemFirestore(url);

      setState(() {
        _urlImagemRecuperada = url;
      });
    }*/

    _atualizarNomeFirestore(){
      String nome = _controllerNome.text;
      FirebaseFirestore db = FirebaseFirestore.instance;

      Map<String, dynamic> dadosAtualizar = {
        "nome" : nome
      };

      db.collection("users").doc(_idUsuarioLogado).update(dadosAtualizar);
      SnackBar snackBar = SnackBar(
            backgroundColor: Colors.green,
            content: Text("Nome atualizado!"),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }

  /* _atualizarUrlImagemFirestore(String url){
      FirebaseFirestore db = FirebaseFirestore.instance;

      Map<String, dynamic> dadosAtualizar = {
        "urlImagem" : url
      };

      db.collection("usuarios").doc(_idUsuarioLogado).update(dadosAtualizar);
    }
  */
  _logOut() async{
    FirebaseAuth auth = FirebaseAuth.instance;
    await auth.signOut();
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(builder: (context) => Login()));
    
    }

    _recuperarDadosUsuario() async {
      FirebaseAuth auth = FirebaseAuth.instance;
      User? usuarioLogado = await auth.currentUser;
      _idUsuarioLogado = usuarioLogado!.uid;

      FirebaseFirestore db = FirebaseFirestore.instance;
      DocumentSnapshot<Map<String, dynamic>> snapshot = await db.collection("users").doc(_idUsuarioLogado).get();

      Map<String, dynamic> dados = snapshot.data()!;
      _controllerNome.text = dados["nome"];

      if( dados["image"] != null ) {
        setState(() {
          _urlImagemRecuperada = dados["image"];
        });
      }
    }

    @override
    void initState() {
      super.initState();
      _recuperarDadosUsuario();
    }

    @override
    Widget build(BuildContext context) {
      return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text('Seu Título'),
          actions: [
            IconButton(
              icon: Icon(
                Icons.menu,
                color: Color.fromARGB(255, 11, 57, 95),
                ),
              onPressed: () {
                _scaffoldKey.currentState!.openEndDrawer();
              },
            ),
          ],
        ),
        body: Container(
          padding: EdgeInsets.all(16),
          child: Center(
            child: SingleChildScrollView(
              child: Column(
                children: <Widget>[
                  
                  CircleAvatar(
                      radius: 100,
                      backgroundColor: Colors.grey,
                      backgroundImage:
                      _urlImagemRecuperada != null
                          ? NetworkImage(_urlImagemRecuperada!)
                          : null
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width/1.1,
                    margin: EdgeInsets.only(top: 50),
                    height: 50,
                    padding: EdgeInsets.only(
                        top: 2,left: 16, right: 16, bottom: 4
                    ),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(
                            Radius.circular(50)
                        ),
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5
                          )
                        ]
                    ),
                    child: TextField(
                      controller: _controllerNome,
                      autofocus: false,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Digite um Nome',
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: () {
                      _atualizarNomeFirestore();
                    },
                    child: Container(
                      height: 50,
                      width: MediaQuery.of(context).size.width/1.1,
                      decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              const Color.fromARGB(255, 11, 57, 95),
                              const Color.fromARGB(255, 11, 57, 95),
                            ],
                          ),
                          borderRadius: BorderRadius.all(
                              Radius.circular(50)
                          )
                      ),
                      child: Center(
                        child: Text('Salvar'.toUpperCase(),
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
        endDrawer: Drawer(
          width: 200,
          shadowColor: Color.fromARGB(255, 11, 57, 95),
        child: ListView(
        padding: EdgeInsets.zero,
        children: [
        ListTile(
          leading: Icon(
            Icons.exit_to_app,
            color: Colors.red,
          ),
          title: Text('Logout',
          style: TextStyle(
            fontSize: 16 ,
          ),
          ),
          onTap: () {
            _logOut();
            _scaffoldKey.currentState!.openEndDrawer(); // Feche o Drawer
          },
        ),
      ],
    ),
  ),
      );
    }
  }