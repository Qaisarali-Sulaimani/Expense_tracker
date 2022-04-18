import 'package:expense_tracker/screens/Expense%20Tracker/expense_tracker.dart';
import 'package:expense_tracker/screens/firstinfopage.dart';
import 'package:expense_tracker/screens/homepage.dart';
import 'package:expense_tracker/screens/login.dart';
import 'package:expense_tracker/screens/sign_up.dart';
import 'package:expense_tracker/screens/splash_screen.dart';
import 'package:expense_tracker/screens/splash_screen2.dart';
import 'package:expense_tracker/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

void main() async {
  await AuthService.fromFirebase().initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: Splash_Screen.id,
      routes: {
        Splash_Screen.id: (context) => const Splash_Screen(),
        SignUp.id: (context) => const SignUp(),
        LoginPage.id: (context) => const LoginPage(),
        Splash_Screen2.id: (context) => const Splash_Screen2(),
        HomePage.id: (context) => const HomePage(),
        FirstPage.id: (context) => const FirstPage(),
        ExpenseTracker.id: (context) => const ExpenseTracker(),
      },
    );
  }
}
