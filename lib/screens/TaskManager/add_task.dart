import 'package:expense_tracker/services/cloud/task.dart';
import 'package:expense_tracker/services/cloud/task_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../constants.dart';

class AddTaskScreen extends StatefulWidget {
  final Task? myTask;
  const AddTaskScreen({this.myTask, Key? key}) : super(key: key);

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  //
  String name = "";
  bool isClick = false;
  bool check = false;
  DateTime _chosenDateTime = DateTime.now();
  late String month, year;
  late TextEditingController _title, _data;

  void showDatePicker(ctx) {
    double h = MediaQuery.of(ctx).size.height;
    showCupertinoModalPopup(
      context: ctx,
      builder: (_) => Container(
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 255, 255, 255),
          borderRadius: BorderRadius.circular(25),
        ),
        height: h * 0.4,
        child: Column(
          children: [
            SizedBox(
              height: h * 0.3,
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.date,
                initialDateTime: DateTime.now(),
                onDateTimeChanged: (val) {
                  setState(() {
                    _chosenDateTime = val;
                    month = _chosenDateTime.month.toString();
                    year = _chosenDateTime.year.toString();
                  });
                },
              ),
            ),

            // Close the modal
            CupertinoButton(
              child: const Text('OK'),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
          ],
        ),
      ),
    );
  }

  void moveToHome(BuildContext context) async {
    if (_title.text.isEmpty || _data.text.isEmpty) {
      if (_title.text.isEmpty) {
        await showErrorDialog(
            context: context, text: "Task name can not be empty");
      } else {
        await showErrorDialog(
            context: context, text: "Task details can not be empty");
      }
      return;
    }

    setState(() {
      isClick = true;
    });

    if (widget.myTask == null) {
      Task task = await FirebaseCloudStorage().createNewTask();
      await FirebaseCloudStorage().updateTask(
        id: task.id,
        taskName: _title.text,
        taskDetails: _data.text,
        month: month,
        year: year,
        isdone: check,
      );
    } else {
      await FirebaseCloudStorage().updateTask(
        id: widget.myTask!.id,
        taskName: _title.text,
        taskDetails: _data.text,
        month: month,
        year: year,
        isdone: check,
      );
    }
    await await Future.delayed(const Duration(seconds: 1));
    Navigator.pop(context);
    setState(() {
      isClick = false;
    });
  }

  @override
  void initState() {
    _title = TextEditingController();
    _data = TextEditingController();
    month = _chosenDateTime.month.toString();
    year = _chosenDateTime.year.toString();

    if (widget.myTask != null) {
      _title.text = widget.myTask!.taskName;
      _data.text = widget.myTask!.taskDetails;
      check = widget.myTask!.isdone;
      month = widget.myTask!.month;
      year = widget.myTask!.year;
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
        title: widget.myTask == null
            ? const Text("Add Task")
            : const Text("Update Task"),
        backgroundColor: Colors.purple[900],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              MyInputField(
                hintText: "Enter Task Name",
                keyboard: TextInputType.name,
                controller: _title,
              ),
              MyInputField(
                hintText: "Enter Task details",
                keyboard: TextInputType.multiline,
                controller: _data,
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      showDatePicker(context);
                    },
                    icon: const Icon(
                      Icons.calendar_month,
                      color: kmycolor,
                      size: 30,
                    ),
                  ),
                  Text(
                    "$month/$year",
                    style: const TextStyle(
                      fontSize: 19,
                      color: kmycolor,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  const SizedBox(
                    width: 8,
                  ),
                  const Text(
                    "STATUS",
                    style: TextStyle(
                      fontSize: 19,
                      color: kmycolor,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(
                    width: 8,
                  ),
                  Checkbox(
                    value: check,
                    onChanged: (value) {
                      setState(() {
                        check = value!;
                      });
                    },
                    fillColor: MaterialStateProperty.all(kmycolor),
                  ),
                ],
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
                            widget.myTask == null ? "ADD" : "UPDATE",
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
