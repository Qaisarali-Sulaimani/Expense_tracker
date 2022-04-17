import 'package:expense_tracker/screens/sign_up.dart';
import 'package:expense_tracker/screens/splash_screen2.dart';
import 'package:expense_tracker/services/auth/auth_exceptions.dart';
import 'package:expense_tracker/services/auth/auth_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:expense_tracker/constants.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);
  static String id = "login_page";

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late TextEditingController _email;
  late TextEditingController _password;
  bool show = false;

  @override
  void initState() {
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        title: const Text(
          "Login",
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: show,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                MyInputField(
                  hintText: "Email",
                  keyboard: TextInputType.emailAddress,
                  controller: _email,
                ),
                MyInputField(
                  hintText: "Password",
                  keyboard: TextInputType.visiblePassword,
                  protect: true,
                  controller: _password,
                ),
                const SizedBox(
                  height: 10,
                ),
                MyButton(
                  text: "Login",
                  mycolor: kmycolor,
                  mytextcolor: Colors.white,
                  onpress: () async {
                    setState(() {
                      show = true;
                    });
                    try {
                      await AuthService.fromFirebase()
                          .logIn(email: _email.text, password: _password.text);
                      setState(() {
                        show = false;
                      });
                      Navigator.pushNamedAndRemoveUntil(
                          context, Splash_Screen2.id, (route) => false);
                    } on UserNotFoundAuthException {
                      await showErrorDialog(
                          context: context,
                          text: "Cannot find user with given credentials!!");
                    } on WrongPasswordAuthException {
                      await showErrorDialog(
                          context: context, text: "Wrong Credentials!!");
                    } on GenericAuthException {
                      await showErrorDialog(
                          context: context, text: "Authentication Error!!");
                    }
                    setState(() {
                      show = false;
                    });
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                  onPressed: () {},
                  child: const Text(
                    "Forgot Password?",
                    style: TextStyle(
                      color: kmycolor,
                      fontWeight: FontWeight.w600,
                      fontSize: 18.0,
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      const TextSpan(
                        text: 'Don\'t have an account yet? ',
                        style: TextStyle(
                          color: Color(0xff91919F),
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0,
                        ),
                      ),
                      TextSpan(
                        text: 'Sign Up',
                        style: const TextStyle(
                          color: kmycolor,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                          fontSize: 16,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, SignUp.id, (route) => false);
                          },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
