import 'package:flutter/material.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'Login.dart';
import 'model/Usuario.dart';
import 'dart:math';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';

class NewPost extends StatefulWidget {
  const NewPost({super.key});

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
  File? _imageFile;
  final ImagePicker _picker = ImagePicker();
  TextEditingController descricaoController = TextEditingController();
  TextEditingController localizacaoController = TextEditingController();


   Future<void> _pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);

    setState(() {
      _imageFile = pickedFile != null ? File(pickedFile.path) : null;
    });
  }

   Future<void> _uploadPost() async {
    if (_imageFile == null || descricaoController.text.isEmpty || localizacaoController.text.isEmpty) {
      return;
    }

    try {
      User? user = FirebaseAuth.instance.currentUser;
      if (user != null) {
      final storage = firebase_storage.FirebaseStorage.instance;
      final storageRef = storage.ref();

      String fileName = 'image_${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(999999)}';

      final fileRef = storageRef.child('images/$fileName.jpg');

      await fileRef.putFile(_imageFile!);

      final String imageUrl = await fileRef.getDownloadURL();

      DocumentSnapshot userSnapshot = await FirebaseFirestore.instance.collection('users').doc(user.uid).get();
      String urlPhotoUserLogged = userSnapshot['image'];

        CollectionReference posts = FirebaseFirestore.instance.collection('posts');

        await posts.add({
          'body': descricaoController.text,
          'localization': localizacaoController.text,
          'image': imageUrl,
          'usuarioId': user.uid,
          'creactedBy': user.displayName,
          'urlPhotoUserLogged': urlPhotoUserLogged,
          'createdAt': FieldValue.serverTimestamp(),
        });
        

        descricaoController.clear();
        localizacaoController.clear();
        setState(() {
          _imageFile = null;
        });
        SnackBar snackBar = SnackBar(
          backgroundColor: Colors.green,
          content: Text("Post criado!"),
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      }
    } catch (error) {
      print(error.toString());
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.all(16),
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(bottom: 100),
                  child:
                Text('Adicionar novo post',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                ),
                ),
                TextField(
                  controller: descricaoController,
                  decoration: InputDecoration(
                    hintText: 'Descrição',
                    prefixIcon: Icon(Icons.description),
                    contentPadding: EdgeInsets.all(50),
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

                    ) 
                  ),
                  TextField(
                  controller: localizacaoController,
                  decoration: InputDecoration(
                    hintText: 'Localização',
                    prefixIcon: Icon(Icons.local_airport),
                    contentPadding: EdgeInsets.all(20),
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

                    ) 
                  ),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.camera),
              child: Text('Tirar Foto'),
            ),
            ElevatedButton(
              onPressed: () => _pickImage(ImageSource.gallery),
              child: Text('Escolher da Galeria'),
            ),
            ElevatedButton(
              onPressed: _uploadPost,
              child: Text("Publicar"),
            )
              ],
            ),
          ),
        ),
      ),
    );
  }
}