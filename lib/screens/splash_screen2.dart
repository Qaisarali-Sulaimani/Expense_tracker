// ignore_for_file: camel_case_types,

import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:expense_tracker/screens/homepage.dart';
import 'package:flutter/material.dart';

class Splash_Screen2 extends StatefulWidget {
  const Splash_Screen2({Key? key}) : super(key: key);
  static String id = "Splash_Screen2";

  @override
  _Splash_Screen2State createState() => _Splash_Screen2State();
}

class _Splash_Screen2State extends State<Splash_Screen2> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 1500,
      splash: Column(
        children: const <Widget>[
          Icon(
            Icons.check_box,
            size: 30,
            color: Colors.green,
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            "You are all set!",
            style: TextStyle(
              fontSize: 23,
              color: Colors.black,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
      nextScreen: const HomePage(),
      backgroundColor: Colors.white,
    );
  }
}
