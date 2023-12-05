/*import 'dart:html';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:travel_vibe_app/Profile.dart';
import 'NewPost.dart';
import 'ButtonNavigator.dart';

class PostData {
  final String image;
  final String body;
  final String localization;
  final String creactedBy;
  final String? urlPhotoUserLogged;

  PostData({
    required this.image,
    required this.body,
    required this.localization,
    required this.creactedBy,
    required this.urlPhotoUserLogged,
  });
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}
class _HomeState extends State<Home> {
    late String _idUsuarioLogado;
  late Map<String, bool> _curtidas = {};
  
  bool isLiked = false; 
  int segmentedControlValue = 0;

  CollectionReference<Map<String, dynamic>> posts = FirebaseFirestore.instance.collection('posts');
    List<PostData> postsData = [];
  //List<String> imagens = []; // Lista para armazenar os links das imagens
 
 @override
  void initState() {
    super.initState();
    // Chama getPosts quando a página inicial é inserida na árvore de widgets
    getPosts();
  }

  _curtirPost(String idPost) async{
    FirebaseFirestore db = FirebaseFirestore.instance;

    if(_curtidas.containsKey(idPost) && _curtidas[idPost] == true) {
      await db.collection('posts').doc(idPost).update({
        'curtir':FieldValue.arrayRemove([_idUsuarioLogado])
      });
      setState(() {
        _curtidas[idPost] = true;
      });
    }
  }

  Future<void> getPosts() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot = await posts.get();
      List<PostData> postsList = querySnapshot.docs.map((doc) {
        return PostData(
          image: doc.data()['image'] as String,
          body: doc.data()['body'] as String,
          creactedBy: doc.data()['creactedBy'] as String,
          localization: doc.data()['localization'] as String,
          urlPhotoUserLogged: doc.data()['urlPhotoUserLogged'] == null ? null : doc.data()['urlPhotoUserLogged'] as String,
        );
      }).toList();

      setState(() {
        postsData = postsList;
      });
    } catch (e) {
      print('Erro ao buscar posts: $e');
    }
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: GlobalKey(), // Adicione esta linha
      body: Stack(
        children: [
         Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
            Expanded(
            child: ListView.builder(
              itemCount: postsData.length,
              itemBuilder: (context, index) {
                return Container (
                margin: EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                  CircleAvatar(
                    backgroundImage: postsData[index].urlPhotoUserLogged != null ? NetworkImage(postsData[index].urlPhotoUserLogged!) : null,
                  ),
                  SizedBox(width: 8),
                    Text(
                    '${postsData[index].creactedBy}',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                    ),
                  ],
                  ),
                SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.network(
                    postsData[index].image,
                ),
                ),
                 SizedBox(height: 4),
                Text(
                  '${postsData[index].body}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text('${postsData[index].localization}',
                style: TextStyle(
                ),

                ),
                StreamBuilder(
                  stream: FirebaseFirestore.instance.collection('posts').snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                     if (snapshot.connectionState == ConnectionState.waiting) {
                     return CircularProgressIndicator();
                  }
                   if (snapshot.hasError) {
                    return Text('Erro ao carregar os dados: ${snapshot.error}');
                  }
                  return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    var post = snapshot.data!.docs[index].data();
                    var idPost = snapshot.data!.docs[index].id;
                  
                  ListTile(
                    trailing: IconButton(
                      icon: Icon(
                        _curtidas.containsKey(idPost) && _curtidas[idPost] == true ? Icons.thumb_up : Icons.thumb_up_outlined,
                      ),
                      onPressed: (){
                        _curtirPost(idPost);
                      },
                    ),
                  );
                  },
                  
                );
                  },
                )
               
                ],
              ),
                );
              },
            ),
          ),
        ]
        ),
      ],
    ),
        
  );    
  
}
}*/







import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_auth/firebase_auth.dart';

class PostData {
  final String idPost;
  final String image;
  final String body;
  final String localization;
  final String creactedBy;
  final String? urlPhotoUserLogged;

  PostData({
    required this.idPost,
    required this.image,
    required this.body,
    required this.localization,
    required this.creactedBy,
    required this.urlPhotoUserLogged,
  });
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  late String _idUsuarioLogado;
  late Map<String, bool> _curtidas = {};
  List<PostData> postsData = [];

  @override
  void initState() {
    super.initState();
    _recuperarDadosUsuario();
    getPosts();
  }

  _recuperarDadosUsuario() async {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? usuarioLogado = await auth.currentUser;
    setState(() {
      _idUsuarioLogado = usuarioLogado!.uid;
    });
  }

  _curtirPost(String idPost) async {
    FirebaseFirestore db = FirebaseFirestore.instance;

    if (_curtidas.containsKey(idPost) && _curtidas[idPost] == true) {
      // Removendo a curtida se já curtiu
      await db.collection('posts').doc(idPost).update({
        'curtidas': FieldValue.arrayRemove([_idUsuarioLogado])
      });
      setState(() {
        _curtidas[idPost] = false;
      });
    } else {
      // Adicionando a curtida se não curtiu
      await db.collection('posts').doc(idPost).update({
        'curtidas': FieldValue.arrayUnion([_idUsuarioLogado])
      });
      setState(() {
        _curtidas[idPost] = true;
      });
    }
  }

  Future<void> getPosts() async {
    try {
      QuerySnapshot<Map<String, dynamic>> querySnapshot =
          await FirebaseFirestore.instance.collection('posts').get();
      List<PostData> postsList = querySnapshot.docs.map((doc) {
        return PostData(
          idPost: doc.id,
          image: doc.data()['image'] as String,
          body: doc.data()['body'] as String,
          creactedBy: doc.data()['creactedBy'] as String,
          localization: doc.data()['localization'] as String,
          urlPhotoUserLogged: doc.data()['urlPhotoUserLogged'] == null
              ? null
              : doc.data()['urlPhotoUserLogged'] as String,
        );
      }).toList();

      setState(() {
        postsData = postsList;
      });
    } catch (e) {
      print('Erro ao buscar posts: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: GlobalKey(),
      body: Stack(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: postsData.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.all(8.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: postsData[index]
                                            .urlPhotoUserLogged !=
                                        null
                                    ? NetworkImage(
                                        postsData[index].urlPhotoUserLogged!)
                                    : null,
                              ),
                              SizedBox(width: 8),
                              Text(
                                '${postsData[index].creactedBy}',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.network(
                              postsData[index].image,
                            ),
                          ),
                          SizedBox(height: 4),
                          
                          Text(
                            '${postsData[index].body}',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          
                          Row(
                            children: <Widget>[
                              Expanded(
                                child: Text(
                                          '${postsData[index].localization}',
                                          style: TextStyle(),
                                        ),
                              ),
                              Expanded(
                                child: ListTile(
                                          trailing: IconButton(
                                            icon: Icon(
                                              color: Colors.red,
                                              _curtidas.containsKey(postsData[index].idPost) &&
                                                      _curtidas[postsData[index].idPost] == true
                                                  ? Icons.favorite 
                                                  : Icons.favorite_border_outlined,
                                            ),
                                            onPressed: () {
                                              _curtirPost(postsData[index].idPost);
                                            },
                                          ),
                                        ),
                              )
                            ],
                          )

                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}