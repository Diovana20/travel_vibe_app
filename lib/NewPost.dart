import 'package:flutter/material.dart';
import 'Login.dart';
import 'model/Usuario.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class NewPost extends StatefulWidget {
  const NewPost({super.key});

  @override
  State<NewPost> createState() => _NewPostState();
}

class _NewPostState extends State<NewPost> {
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
                  margin: EdgeInsets.only(bottom: 200),
                  child:
                Text('Adicionar novo post',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
                ),
                ),
                TextField(
                  decoration: InputDecoration(
                    hintText: 'Descrição',
                    prefixIcon: Icon(Icons.description),
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
                  TextField(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}