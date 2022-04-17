import 'package:expense_tracker/constants.dart';
import 'package:expense_tracker/screens/Expense%20Tracker/expense_tracker.dart';
import 'package:expense_tracker/screens/TaskManager/by_pagination.dart';
import 'package:expense_tracker/screens/firstinfopage.dart';
import 'package:expense_tracker/screens/homepage.dart';
import 'package:expense_tracker/services/auth/auth_service.dart';
import 'package:flutter/material.dart';

class DrawerPage extends StatelessWidget {
  const DrawerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: <Widget>[
        DrawerHeader(
          padding: const EdgeInsets.all(0),
          child: UserAccountsDrawerHeader(
            decoration: BoxDecoration(
              color: Colors.purple[900],
            ),
            accountName: Text(
              "WELCOME ${AuthService.fromFirebase().currentuser!.name.toUpperCase().toString()}",
              style: const TextStyle(
                fontSize: 18,
              ),
            ),
            accountEmail: Text(
              AuthService.fromFirebase().currentuser!.email.toString(),
              style: const TextStyle(
                fontSize: 15,
              ),
            ),
          ),
        ),
        InkWell(
          child: const Mytile(
            myicon: Icons.home,
            mytext: "Home",
          ),
          onTap: () {
            Navigator.pushNamedAndRemoveUntil(
                context, HomePage.id, (route) => false);
          },
        ),
        InkWell(
          child: const Mytile(
            myicon: Icons.task,
            mytext: "Task Manager",
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Pagination(),
              ),
            );
          },
        ),
        InkWell(
          child: const Mytile(
            myicon: Icons.monetization_on,
            mytext: "Expense Tracker",
          ),
          onTap: () {
            Navigator.pushNamed(context, ExpenseTracker.id);
          },
        ),
        InkWell(
          child: const Mytile(
            myicon: Icons.logout,
            mytext: "Logout",
          ),
          onTap: () async {
            bool? shouldLogout = await showGenericDialog(
              context: context,
              title: "Sign Out",
              content: "Do you really want to log out?",
              optionBuilder: () {
                return {
                  "OK": true,
                  "CANCEL": false,
                };
              },
            );

            if (shouldLogout != null && shouldLogout == true) {
              await AuthService.fromFirebase().logOut();
              Navigator.pushNamedAndRemoveUntil(
                  context, FirstPage.id, (route) => false);
            }
          },
        ),
      ],
    );
  }
}

class Mytile extends StatelessWidget {
  final IconData myicon;
  final String mytext;
  const Mytile({required this.myicon, required this.mytext, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(
        myicon,
        color: Colors.purple[900],
        size: 27,
      ),
      title: Text(
        mytext,
        textScaleFactor: 1.4,
        style: TextStyle(
          color: Colors.purple[900],
        ),
      ),
    );
  }
}
