// ignore_for_file: unused_import

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:project/reusable_widgets/reusable_widget.dart';
import 'package:project/screens/home_screen.dart';
import 'package:project/screens/signup_screen.dart';
import 'package:project/utils/color_utils.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import '../User/user_provider.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {

  TextEditingController _passwordTextController = TextEditingController();
  TextEditingController _emailTextController = TextEditingController();
  late String userID;

  Future<String?> findUserIdByEmail(String _emailTextController) async {
    final CollectionReference usersCollection =
        FirebaseFirestore.instance.collection('User');

    QuerySnapshot querySnapshot = await usersCollection
        .where('email', isEqualTo: _emailTextController)
        .limit(1)
        .get();

    if (querySnapshot.docs.isNotEmpty) {
      userID = querySnapshot.docs.first.id;
      return userID;
    } else {
      return null;
    }
  }
  //user id take
  /*String? userId = await findUserIdByEmail('example@example.com');

    if (userId != null) {
      // User ID found, do something with it
      print('User ID: $userId');
    } else {
      // User not found
      print('User not found');
    }*/
  
  @override
  Widget build(BuildContext context) {
    final UserProvider userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      body: Container(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              hexStringColor("4b0082"),
              hexStringColor("800080"),
              hexStringColor("4b0082")
            ], begin: Alignment.topCenter, end: Alignment.bottomCenter
            )
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.fromLTRB(20, MediaQuery.of(context).size.height * 0.2, 20, 0),
                child: Column(
                  children: <Widget>[
                    logoWidget("assets/images/icon_receipt.png"),
                    SizedBox(
                      height: 30,
                    ),
                    reusableTextField("Enter Email", Icons.person_outline, false, _emailTextController,null),
                    SizedBox(
                      height: 30,
                    ),
                    reusableTextField("Enter Password", Icons.lock_outline, true, _passwordTextController,null),
                    SizedBox(
                      height: 30,
                    ),
                    SignInSignUpButton(context, true,() async{
                      try{
                        FirebaseAuth.instance.signInWithEmailAndPassword(email: _emailTextController.text
                        , password: _passwordTextController.text).then((value) async {
                          Fluttertoast.showToast(
                            msg: "Log in Succesful",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 2,
                            fontSize: 12
                          );
                          await userProvider.loginWithEmail(_emailTextController.text);
                           
                          //Provider.of<UserProvider>(context, listen: false).setUserId(userID);
                          //Navigator.push(context, MaterialPageRoute(builder: (context) =>HomeScreen(*put userID here* || userID : mahba || user: userID) ));
                          Navigator.push(context, MaterialPageRoute(builder: (context) =>HomeScreen() ));
                        }).catchError((error){
                          Fluttertoast.showToast(
                            msg: "Email or password has error",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 2,
                            fontSize: 12,
                            backgroundColor: Colors.grey,
                            textColor: Colors.black
                            );
                        });
                        }catch(e){
                          String error = e.toString();
                          String errorMessage = 'An error occurred. Please try again.';
                          if (error.contains('invalid-email')) {
                            Fluttertoast.showToast(
                            msg: "Email is not valid",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 2,
                            fontSize: 12
                            );
                          errorMessage = 'Email is not valid';
                          } else if (error.contains('operation-not-allowed')) {
                            Fluttertoast.showToast(
                            msg: "Email is not valid",
                            toastLength: Toast.LENGTH_SHORT,
                            gravity: ToastGravity.BOTTOM,
                            timeInSecForIosWeb: 2,
                            fontSize: 12
                            );
                            errorMessage = 'Email is not available. Please contact our Customer Service.';
                          } else if (error.contains('weak-password')) {
                            errorMessage = 'Password is not strong enough';
                          }
                          print(errorMessage); }
                      
                    }),
                    signUpOption()
                  ]
                  ),
                  ),
                  ),
            ),
            );
    
  }

  Row signUpOption(){
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text("Don't have account?",
        style: TextStyle(color: Colors.white70),),
        GestureDetector(
          onTap: (){
            Navigator.push(context,
            MaterialPageRoute(builder: ((context) => SignUpScreen())));
          },
          child: const Text(
            " Sign Up",
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
          ),
        )
      ],
      
    );
    
  }

}
