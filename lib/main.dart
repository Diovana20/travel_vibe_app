import 'package:flutter/material.dart';
import 'package:travel_vibe_app/Home.dart';
import 'package:travel_vibe_app/Profile.dart';
import 'Login.dart';
import 'Home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  //FirebaseFirestore.instance.collection("usuarios").doc().set({"nome": "Nome Teste2"});

  runApp(MaterialApp(
    home: Login(),
    debugShowCheckedModeBanner: false
  ));
}
