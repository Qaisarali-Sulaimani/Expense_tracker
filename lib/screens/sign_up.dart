import 'package:expense_tracker/constants.dart';
import 'package:expense_tracker/screens/login.dart';
import 'package:expense_tracker/screens/splash_screen2.dart';
import 'package:expense_tracker/services/auth/auth_exceptions.dart';
import 'package:expense_tracker/services/auth/auth_service.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);
  static String id = "sign_up";

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  late TextEditingController _name;
  late TextEditingController _email;
  late TextEditingController _password;
  bool show = false;

  @override
  void initState() {
    _name = TextEditingController();
    _email = TextEditingController();
    _password = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    _name.dispose();
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
          "Sign Up",
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
                  hintText: "Name",
                  keyboard: TextInputType.name,
                  controller: _name,
                ),
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
                  text: "Sign Up",
                  mycolor: kmycolor,
                  mytextcolor: Colors.white,
                  onpress: () async {
                    setState(() {
                      show = true;
                    });
                    try {
                      await AuthService.fromFirebase().createUser(
                          email: _email.text,
                          password: _password.text,
                          name: _name.text);
                      setState(() {
                        show = false;
                      });
                      Navigator.pushNamedAndRemoveUntil(
                          context, Splash_Screen2.id, (route) => false);
                    } on EmailAlreadyInUseAuthException {
                      await showErrorDialog(
                          context: context, text: "Email already in use!!");
                    } on InValidEmailAuthException {
                      await showErrorDialog(
                          context: context, text: "Email is invalid!!");
                    } on GenericAuthException {
                      await showErrorDialog(
                          context: context, text: "Registration Error!!");
                    }
                    setState(() {
                      show = false;
                    });
                  },
                ),
                const SizedBox(
                  height: 10,
                ),
                RichText(
                  text: TextSpan(
                    children: <TextSpan>[
                      const TextSpan(
                        text: 'Already have an account? ',
                        style: TextStyle(
                          color: Color(0xff91919F),
                          fontWeight: FontWeight.w500,
                          fontSize: 16.0,
                        ),
                      ),
                      TextSpan(
                        text: 'Login',
                        style: const TextStyle(
                          color: kmycolor,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline,
                          fontSize: 16,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            Navigator.pushNamedAndRemoveUntil(
                                context, LoginPage.id, (route) => false);
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
