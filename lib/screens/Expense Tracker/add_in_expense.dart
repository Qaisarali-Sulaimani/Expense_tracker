import 'package:expense_tracker/services/cloud_expense/model.dart';
import 'package:expense_tracker/services/cloud_expense/model_service.dart';
import 'package:flutter/material.dart';

import '../../constants.dart';

class AddInExpense extends StatefulWidget {
  final bool isAdd;
  final TransactionModel? model;
  const AddInExpense({required this.isAdd, this.model, Key? key})
      : super(key: key);

  @override
  State<AddInExpense> createState() => _AddInExpenseState();
}

class _AddInExpenseState extends State<AddInExpense> {
  //
  String name = "";
  bool isClick = false;
  bool check = false;
  late TextEditingController _title, _data;

  //
  void moveToHome(BuildContext context) async {
    if (_title.text.isEmpty || _data.text.isEmpty) {
      if (_title.text.isEmpty) {
        await showErrorDialog(context: context, text: "From can not be empty");
      } else {
        await showErrorDialog(context: context, text: "Money can not be empty");
      }
      return;
    }

    setState(() {
      isClick = true;
    });

    if (widget.model == null) {
      TransactionModel task =
          await FirebaseCloudStorageExpense().createNewTransaction();
      await FirebaseCloudStorageExpense().updateTransaction(
        id: task.id,
        details: _title.text,
        amount: int.parse(_data.text),
        isAdd: widget.isAdd,
      );
    } else {
      await FirebaseCloudStorageExpense().updateTransaction(
        id: widget.model!.id,
        details: _title.text,
        amount: int.parse(_data.text),
        isAdd: widget.isAdd,
      );
    }

    await FirebaseCloudStorageExpense().totalExpenditure();
    await Future.delayed(const Duration(seconds: 1));
    Navigator.pop(context);
    setState(() {
      isClick = false;
    });
  }

  @override
  void initState() {
    _title = TextEditingController();
    _data = TextEditingController();

    if (widget.model != null) {
      _title.text = widget.model!.details;
      _data.text = widget.model!.amount.toString();
    }

    super.initState();
  }

  @override
  void dispose() {
    _title.dispose();
    _data.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double w = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title:
            widget.isAdd ? const Text("Add Income") : const Text("Add Expense"),
        backgroundColor: Colors.purple[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              MyInputField(
                hintText: "Enter From",
                keyboard: TextInputType.name,
                controller: _title,
              ),
              MyInputField(
                hintText: "Enter Money",
                keyboard: TextInputType.number,
                controller: _data,
              ),
              const SizedBox(
                height: 10.0,
              ),
              Material(
                color: Colors.blue,
                borderRadius: BorderRadius.circular(isClick ? 50.0 : 30.0),
                child: InkWell(
                  onTap: () => moveToHome(context),
                  child: AnimatedContainer(
                    duration: Duration(seconds: isClick ? 1 : 0),
                    alignment: Alignment.center,
                    height: 40.0,
                    width: !isClick ? w : 50.0,
                    child: !isClick
                        ? Text(
                            widget.model == null ? "ADD" : "Update",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 20.0,
                            ),
                          )
                        : const Icon(
                            Icons.done,
                            color: Colors.white,
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
