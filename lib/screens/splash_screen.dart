// ignore_for_file: camel_case_types,

import 'package:expense_tracker/constants.dart';
import 'package:expense_tracker/screens/homepage.dart';
import 'package:expense_tracker/services/auth/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'firstinfopage.dart';

class Splash_Screen extends StatefulWidget {
  const Splash_Screen({Key? key}) : super(key: key);
  static String id = "splash_screen";

  @override
  _Splash_ScreenState createState() => _Splash_ScreenState();
}

class _Splash_ScreenState extends State<Splash_Screen> {
  @override
  Widget build(BuildContext context) {
    return AnimatedSplashScreen(
      duration: 1500,
      splash: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const <Widget>[
          Icon(
            Icons.assessment,
            size: 50,
            color: Colors.white,
          ),
          SizedBox(
            width: 10,
          ),
          Text(
            "Assignment# 1",
            style: TextStyle(
              fontSize: 35,
              color: Colors.white,
              fontStyle: FontStyle.italic,
            ),
          ),
        ],
      ),
      nextScreen: AuthService.fromFirebase().currentuser == null
          ? const FirstPage()
          : const HomePage(),
      backgroundColor: kmycolor,
    );
  }
}
