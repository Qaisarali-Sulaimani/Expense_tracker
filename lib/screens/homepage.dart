import 'package:flutter/material.dart';

import 'drawer_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  static const String id = "homePage";

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home"),
        backgroundColor: Colors.purple[900],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(
          Icons.add,
        ),
      ),
      drawer: const Drawer(
        backgroundColor: Colors.white,
        child: DrawerPage(),
      ),
      body: const Center(
        child: Text(
          "Please Navigate through drawer for particular sets",
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 20,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w400,
            letterSpacing: 1.2,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}
