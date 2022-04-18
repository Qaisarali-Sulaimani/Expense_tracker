import 'package:flutter/material.dart';
import '../../services/cloud_expense/model_service.dart';

class Insights extends StatefulWidget {
  const Insights({Key? key}) : super(key: key);

  @override
  State<Insights> createState() => _InsightsState();
}

class _InsightsState extends State<Insights> {
  late int total = 0;
  late int add = 0;
  late int sub = 0;
  late double xx = 0.0;
  bool show = false;

  void doWork() async {
    await Future.delayed(const Duration(seconds: 1));
    final mymap = await FirebaseCloudStorageExpense().totalExpenditure();
    setState(() {
      total = mymap['tot'] as int;
      add = mymap['add'] as int;
      sub = mymap['sub'] as int;
      xx = (add - sub) / add * 100;
      show = true;
    });
  }

  @override
  void initState() {
    doWork();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: show
          ? Center(
              child: Text(
                sub > add
                    ? "You are spending too much money. You save only $xx% of your income."
                    : "Good job. You are saving $xx% of your income.",
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 20,
                  fontStyle: FontStyle.italic,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 1.2,
                  color: Colors.black,
                ),
              ),
            )
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}
