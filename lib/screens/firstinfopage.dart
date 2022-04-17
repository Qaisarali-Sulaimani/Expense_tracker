import 'package:expense_tracker/constants.dart';
import 'package:expense_tracker/screens/login.dart';
import 'package:expense_tracker/screens/sign_up.dart';
import 'package:flutter/material.dart';
import 'package:page_view_indicators/page_view_indicators.dart';

class FirstPage extends StatefulWidget {
  const FirstPage({Key? key}) : super(key: key);
  static const String id = "firstPage";

  @override
  State<FirstPage> createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  final ValueNotifier<int> _pageNotifier = ValueNotifier<int>(0);
  final PageController _pageController = PageController();

  final List<MyPage> list = [
    MyPage(
        myImage: Image.asset("resouces/onboarding_1.png"),
        text1st: "Gain total control of your money",
        text2nd: "Become your own money manager and make every cent count"),
    MyPage(
        myImage: Image.asset("resouces/onboarding_2.png"),
        text1st: "Know where your money goes",
        text2nd:
            "Track your transaction easily, with categories and financial report "),
    MyPage(
        myImage: Image.asset("resouces/onboarding_3.png"),
        text1st: "Planning ahead",
        text2nd: "Setup your budget for each category so you in control"),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(25.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 450,
              child: PageView.builder(
                itemCount: list.length,
                controller: _pageController,
                itemBuilder: (context, i) {
                  return Column(
                    children: <Widget>[
                      list[i].myImage,
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        list[i].text1st,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(
                        height: 12,
                      ),
                      Text(
                        list[i].text2nd,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xff91919F),
                        ),
                      ),
                    ],
                  );
                },
                onPageChanged: (index) {
                  setState(() {
                    _pageNotifier.value = index;
                  });
                },
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            CirclePageIndicator(
              currentPageNotifier: _pageNotifier,
              itemCount: list.length,
              selectedSize: 15,
              selectedDotColor: kmycolor,
            ),
            const Spacer(),
            MyButton(
              text: "Sign Up",
              mycolor: kmycolor,
              mytextcolor: Colors.white,
              onpress: () {
                Navigator.pushNamed(context, SignUp.id);
              },
            ),
            MyButton(
              text: "Login",
              mycolor: kbtncolor,
              mytextcolor: kmycolor,
              onpress: () {
                Navigator.pushNamed(context, LoginPage.id);
              },
            ),
          ],
        ),
      ),
    );
  }
}

class MyPage {
  final Image myImage;
  final String text1st;
  final String text2nd;

  MyPage({required this.myImage, required this.text1st, required this.text2nd});
}
