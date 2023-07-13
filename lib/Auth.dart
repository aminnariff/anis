// ignore_for_file: unused_local_variable

import 'package:firebase_auth/firebase_auth.dart';

class Auth {
  //creating new instance of firebase auth

  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<void>  registerWithEmailandPassword (
    String email, String password) async {
      await _auth.createUserWithEmailAndPassword(
        email: email, 
        password: password
        );
    }

    Future<void>  signInWithEmailandPassword (
    String email, String password) async {
      final user = await _auth.signInWithEmailAndPassword(
        email: email, 
        password: password
        );
    }
  }