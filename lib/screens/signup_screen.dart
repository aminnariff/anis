// ignore_for_file: unused_import

import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:project/reusable_widgets/reusable_widget.dart';
import 'package:project/screens/home_screen.dart';
import 'package:project/screens/signin_screen.dart';
import 'package:project/utils/color_utils.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({Key? key}) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final password = TextEditingController();
  final email = TextEditingController();
  final username = TextEditingController();
  final work = TextEditingController();
  final salary = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Sign Up",
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                colors: [hexStringColor("4b0082"), hexStringColor("800080"), hexStringColor("4b0082")],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter)),
        child: SingleChildScrollView(
          padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).size.width * 0.2, 20, 0),
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 20,
              ),
              //reusableTextField(text, icon, isPasswordType, controller, param4)
              reusableTextField("Enter Username", Icons.person_outline, false, username, null),
              const SizedBox(
                height: 20,
              ),
              reusableTextField("Enter Job", Icons.work, false, work, null),
              const SizedBox(
                height: 20,
              ),
              reusableTextField("Enter Annual Salary", Icons.money_outlined, false, salary, null),
              const SizedBox(
                height: 20,
              ),
              reusableTextField("Enter Email", Icons.person_outline, false, email, null),
              const SizedBox(
                height: 20,
              ),
              reusableTextField("Enter Password", Icons.lock_outline, true, password, null),
              const SizedBox(
                height: 20,
              ),
              SignInSignUpButton(context, false, () {
                try {
                  FirebaseAuth.instance
                      .createUserWithEmailAndPassword(email: email.text, password: password.text)
                      .then((value) {
                    print("Created New Account");
                    Map<String, dynamic> data = {
                      "Username": username.text,
                      "Work": work.text,
                      "Annual Salary": salary.text,
                      "Email": email.text,
                      "Password": password.text
                    };
                    FirebaseFirestore.instance.collection("User").add(data);
                    Fluttertoast.showToast(
                        msg: "Sign Up Succesful",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 2,
                        fontSize: 12);
                    Navigator.push(context, MaterialPageRoute(builder: (context) => const SignInScreen()));
                  }).catchError((error) {
                    //betulkan lagi for error lain
                    Fluttertoast.showToast(
                        msg: "An error occurred. Please try again.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 2,
                        fontSize: 12);
                  });
                } catch (e) {
                  String error = e.toString();
                  String errorMessage = 'An error occurred. Please try again.';
                  if (error.contains('email-already-in-use')) {
                    Fluttertoast.showToast(
                        msg: "Email already in used",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 2,
                        fontSize: 12);
                    errorMessage = 'Email already in use';
                  } else if (error.contains('invalid-email')) {
                    Fluttertoast.showToast(
                        msg: "Email is invalid",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 2,
                        fontSize: 12);
                    errorMessage = 'Email is not valid';
                  } else if (error.contains('operation-not-allowed')) {
                    Fluttertoast.showToast(
                        msg: "Email is not available. Please contact our Customer Service.",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 2,
                        fontSize: 12);
                    errorMessage = 'Email is not available. Please contact our Customer Service.';
                  } else if (error.contains('weak-password')) {
                    Fluttertoast.showToast(
                        msg: "Password is not strong enough",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIosWeb: 2,
                        fontSize: 12);
                    errorMessage = 'Password is not strong enough';
                  }
                  print(errorMessage);
                }
              }),
            ],
          ),
        ),
      ),
    );
  }
}
