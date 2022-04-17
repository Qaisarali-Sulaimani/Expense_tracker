import 'dart:async';
import 'package:expense_tracker/screens/Expense%20Tracker/add_in_expense.dart';
import 'package:expense_tracker/services/cloud_expense/model_service.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import '../../constants.dart';
import '../../services/cloud_expense/model_constant.dart';

class ExpenseList extends StatefulWidget {
  const ExpenseList({Key? key}) : super(key: key);

  @override
  State<ExpenseList> createState() => _ExpenseListState();
}

class _ExpenseListState extends State<ExpenseList> {
  late Timer timer;
  late int total = 0;
  late int add = 0;
  late int sub = 0;

  void doWork() async {
    final mymap = await FirebaseCloudStorageExpense().totalExpenditure();
    setState(() {
      total = mymap['tot'] as int;
      add = mymap['add'] as int;
      sub = mymap['sub'] as int;
    });
  }

  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 3), (Timer t) => doWork());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      floatingActionButton: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          FloatingActionButton(
            child: const Icon(
              Icons.add,
            ),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddInExpense(isAdd: true),
                ),
              );
            },
          ),
          const SizedBox(
            height: 10,
          ),
          FloatingActionButton(
            child: const Icon(Icons.remove),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AddInExpense(isAdd: false),
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(24.0),
            child: Card(
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Text(
                          "Net Balance",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        Text(
                          "$total",
                          style: const TextStyle(
                            color: Colors.black,
                            fontSize: 22,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    const Divider(color: Colors.grey),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Text(
                          "Total In(+)",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          "$add",
                          style: const TextStyle(
                            color: Colors.green,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Text(
                          "Total Out(-)",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 20,
                          ),
                        ),
                        Text(
                          "$sub",
                          style: const TextStyle(
                            color: Colors.red,
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: Scrollbar(
              isAlwaysShown: true,
              child: PaginateFirestore(
                itemBuilder: (context, documentSnapshots, index) {
                  final data = documentSnapshots[index].data() as Map?;
                  if (data != null) {
                    return Padding(
                      padding: const EdgeInsets.all(8),
                      child: Card(
                        child: ListTile(
                          textColor: Colors.white,
                          onTap: () {},
                          leading: Text(
                            (index + 1).toString(),
                            textScaleFactor: 1.3,
                            style: const TextStyle(
                              color: Colors.black,
                            ),
                          ),
                          title: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Details: ${data[myDetails]}",
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 20,
                                ),
                                maxLines: 1,
                                softWrap: true,
                              ),
                              Text(
                                "Amount: ${data[myAmount]}",
                                style: TextStyle(
                                  color:
                                      data[myType] ? Colors.green : Colors.red,
                                  fontSize: 20,
                                ),
                                maxLines: 1,
                                softWrap: true,
                              ),
                            ],
                          ),
                          enableFeedback: true,
                          trailing: IconButton(
                            color: Colors.black,
                            onPressed: () async {
                              final shouldDelete = await showGenericDialog(
                                context: context,
                                title: "Delete Transaction",
                                content:
                                    "Do you really want to delete this Transaction?",
                                optionBuilder: () {
                                  return {
                                    "Delete": true,
                                    "Cancel": false,
                                  };
                                },
                              );

                              if (shouldDelete) {
                                await FirebaseCloudStorageExpense()
                                    .deleteTransaction(
                                        documentId:
                                            documentSnapshots[index].id);
                              }
                            },
                            icon: const Icon(Icons.delete),
                          ),
                        ),
                      ),
                    );
                  } else {
                    return const Center(
                      child: Text(
                        "No Results",
                        style: TextStyle(
                          fontSize: 20,
                          fontStyle: FontStyle.italic,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 1.2,
                          color: Colors.black,
                        ),
                      ),
                    );
                  }
                },
                query: FirebaseCloudStorageExpense().myQuery(myAmount),
                itemBuilderType: PaginateBuilderType.listView,
                isLive: true,
                itemsPerPage: 7,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
