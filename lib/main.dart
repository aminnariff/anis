import 'package:camera/camera.dart';
import 'package:firebase_core/firebase_core.dart';
//import 'package:firebase_core_platform_interface/firebase_core_platform_interface.dart';
import 'package:lottie/lottie.dart';
import 'package:project/User/user_provider.dart';
import 'package:project/screens/addreceipt_screen.dart';
//Rimport 'package:project/screens/addreceipt_screen.dart';
import 'package:project/utils/color_utils.dart';
//import 'package:project/reusable_widgets/reusable_widget.dart';
//import 'package:project/screens/home_screen.dart';
import 'User/button_provider.dart';
import 'firebase_options.dart';
import 'package:flutter/material.dart';
import 'package:project/screens/signin_screen.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:provider/provider.dart';

Future main() async{
  WidgetsFlutterBinding.ensureInitialized();
  cameras = await availableCameras();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
    //options: DefaultFirebaseOptions.web, 
    //options: DefaultFirebaseOptions.android
);
   runApp(
        ChangeNotifierProvider(
          create: (_) => ButtonIdProvider(), // Create the provider instance
          child: const MyApp(),
        ),
      );
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => UserProvider(),
      child :MaterialApp(
        title: 'RECEiPTiE',
        theme: ThemeData(
          // This is the theme of your application.
          //
          // Try running your application with "flutter run". You'll see the
          // application has a blue toolbar. Then, without quitting the app, try
          // changing the primarySwatch below to Colors.green and then invoke
          // "hot reload" (press "r" in the console where you ran "flutter run",
          // or simply save your changes to "hot reload" in a Flutter IDE).
          // Notice that the counter didn't reset back to zero; the application
          // is not restarted.
          primarySwatch: Colors.blue,
        ),
        home: const SplashScreen(),
      )
    );
  }
}

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    //return Scaffold();
    return AnimatedSplashScreen(
      splash: Lottie.asset('assets/images/89023-loading-circles.json'),
      backgroundColor: hexStringColor("800080"), 
      nextScreen:const SignInScreen(),
      splashIconSize: 350,
      duration: 4000,
      splashTransition: SplashTransition.fadeTransition,
      pageTransitionType: PageTransitionType.topToBottom,
      animationDuration: const Duration(seconds: 5),
      );
  }
}
