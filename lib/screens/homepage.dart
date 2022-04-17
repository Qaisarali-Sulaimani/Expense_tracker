import 'package:expense_tracker/services/auth/auth_service.dart';
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
      body: Text(AuthService.fromFirebase().currentuser!.name.toString()),
    );
  }
}
