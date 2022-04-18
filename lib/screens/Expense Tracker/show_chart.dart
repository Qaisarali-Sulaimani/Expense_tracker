import 'package:flutter/material.dart';
import 'package:pie_chart/pie_chart.dart';

import '../../services/cloud_expense/model_service.dart';

class ShowChart extends StatefulWidget {
  final bool isTrue;
  const ShowChart({required this.isTrue, Key? key}) : super(key: key);

  @override
  _ShowChartState createState() => _ShowChartState();
}

class _ShowChartState extends State<ShowChart> {
  Map<String, double> list = {};
  bool isDone = false;
  void doWork() async {
    list = await FirebaseCloudStorageExpense().getAll(widget.isTrue);
    setState(() {
      isDone = true;
    });
  }

  @override
  void initState() {
    doWork();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xff757575),
      child: Container(
        padding: const EdgeInsets.all(20.0),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30.0),
            topRight: Radius.circular(30.0),
          ),
        ),
        child: isDone
            ? Center(
                child: list.isNotEmpty
                    ? SizedBox(
                        child: PieChart(
                          dataMap: list,
                          animationDuration: const Duration(milliseconds: 800),
                          chartLegendSpacing: 32,
                          chartRadius: MediaQuery.of(context).size.width / 3.2,
                          initialAngleInDegree: 0,
                          chartType: ChartType.ring,
                          ringStrokeWidth: 32,
                          centerText: widget.isTrue ? "Income" : "Expense",
                          legendOptions: const LegendOptions(
                            showLegendsInRow: false,
                            legendPosition: LegendPosition.bottom,
                            showLegends: true,
                            legendShape: BoxShape.circle,
                            legendTextStyle: TextStyle(
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          chartValuesOptions: const ChartValuesOptions(
                            showChartValueBackground: true,
                            showChartValues: true,
                            showChartValuesInPercentage: false,
                            showChartValuesOutside: false,
                            decimalPlaces: 1,
                          ),
                        ),
                      )
                    : const Center(
                        child: Text(
                          "No entry found for results",
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
              )
            : const Center(
                child: CircularProgressIndicator(),
              ),
      ),
    );
  }
}
