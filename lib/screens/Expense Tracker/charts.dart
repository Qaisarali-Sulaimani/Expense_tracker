import 'package:expense_tracker/constants.dart';
import 'package:flutter/material.dart';

import 'show_chart.dart';

class Charts extends StatefulWidget {
  const Charts({Key? key}) : super(key: key);

  @override
  State<Charts> createState() => _ChartsState();
}

class _ChartsState extends State<Charts> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            MyButton(
              text: "Income",
              mycolor: Colors.green,
              mytextcolor: Colors.white,
              onpress: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => const ShowChart(isTrue: true),
                );
              },
            ),
            MyButton(
              text: "Expense",
              mycolor: Colors.red,
              mytextcolor: Colors.white,
              onpress: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => const ShowChart(isTrue: false),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
