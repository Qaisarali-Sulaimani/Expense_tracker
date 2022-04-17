import 'package:expense_tracker/constants.dart';
import 'package:expense_tracker/screens/Expense%20Tracker/expense_list.dart';
import 'package:flutter/material.dart';

class ExpenseTracker extends StatefulWidget {
  const ExpenseTracker({Key? key}) : super(key: key);
  static const String id = "expense";
  @override
  State<ExpenseTracker> createState() => _ExpenseTrackerState();
}

class _ExpenseTrackerState extends State<ExpenseTracker> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  static const List<Widget> _pages = <Widget>[
    ExpenseList(),
    Icon(
      Icons.camera,
      size: 150,
    ),
    Icon(
      Icons.chat,
      size: 150,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Expense Tracker"),
        backgroundColor: Colors.purple[900],
      ),
      body: IndexedStack(
        index: _selectedIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.list,
            ),
            label: 'List',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.pie_chart,
            ),
            label: 'Charts',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.bar_chart,
            ),
            label: 'Insights',
          ),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
        enableFeedback: true,
        type: BottomNavigationBarType.shifting,
        unselectedIconTheme: const IconThemeData(color: Colors.grey),
        backgroundColor: Colors.white,
        selectedFontSize: 20,
        selectedIconTheme: const IconThemeData(color: kmycolor, size: 30),
        selectedItemColor: kmycolor,
        selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}
