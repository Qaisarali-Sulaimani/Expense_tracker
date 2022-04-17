import 'package:expense_tracker/services/cloud/task.dart';
import 'package:expense_tracker/services/cloud/task_constants.dart';
import 'package:expense_tracker/services/cloud/task_service.dart';
import 'package:flutter/material.dart';
import 'package:paginate_firestore/paginate_firestore.dart';
import '../../constants.dart';
import 'add_task.dart';

class Pagination extends StatefulWidget {
  const Pagination({Key? key}) : super(key: key);

  @override
  State<Pagination> createState() => _PaginationState();
}

class _PaginationState extends State<Pagination> {
  String basis = taskCStatus;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Task Manager"),
        backgroundColor: Colors.purple[900],
        actions: <Widget>[
          PopupMenuButton<String>(
            icon: const Icon(Icons.sort),
            onSelected: (String result) {
              switch (result) {
                case 'name':
                  setState(() {
                    basis = taskCName;
                  });
                  break;
                case 'date':
                  setState(() {
                    basis = taskCDueYear;
                  });
                  break;
                case 'completed':
                  setState(() {
                    basis = taskCStatus;
                  });
                  break;
                default:
              }
            },
            itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
              const PopupMenuItem<String>(
                value: 'name',
                child: Text('name'),
              ),
              const PopupMenuItem<String>(
                value: 'date',
                child: Text('date'),
              ),
              const PopupMenuItem<String>(
                value: 'completed',
                child: Text('completed'),
              ),
            ],
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddTaskScreen(),
            ),
          );
        },
        child: const Icon(
          Icons.add,
        ),
      ),
      body: Scrollbar(
        isAlwaysShown: true,
        child: PaginateFirestore(
          itemBuilder: (context, documentSnapshots, index) {
            final data = documentSnapshots[index].data() as Map?;
            if (data != null) {
              return Padding(
                padding: const EdgeInsets.all(8),
                child: Card(
                  shape: const StadiumBorder(),
                  color: Colors.lightBlueAccent,
                  child: ListTile(
                    textColor: Colors.white,
                    shape: const StadiumBorder(),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AddTaskScreen(
                            myTask: Task(
                              id: documentSnapshots[index].id,
                              isdone: data[taskCStatus],
                              month: data[taskCDueMonth],
                              year: data[taskCDueYear],
                              taskDetails: data[taskCDetails],
                              taskName: data[taskCName],
                            ),
                          ),
                        ),
                      );
                    },
                    leading: Text(
                      (index + 1).toString(),
                      textScaleFactor: 1.3,
                    ),
                    title: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Task: ${data[taskCName]}",
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                          maxLines: 1,
                          softWrap: true,
                        ),
                        const SizedBox(
                          height: 5,
                        ),
                        Text(
                          "Due: ${data[taskCDueMonth]}/${data[taskCDueYear]}",
                          style: const TextStyle(
                            fontSize: 18,
                          ),
                        )
                      ],
                    ),
                    enableFeedback: true,
                    trailing: IconButton(
                      color: Colors.white,
                      onPressed: () async {
                        final shouldDelete = await showGenericDialog(
                          context: context,
                          title: "Delete Task",
                          content: "Do you really want to delete this Task?",
                          optionBuilder: () {
                            return {
                              "Delete": true,
                              "Cancel": false,
                            };
                          },
                        );

                        if (shouldDelete) {
                          await FirebaseCloudStorage().deleteNote(
                              documentId: documentSnapshots[index].id);
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
          query: FirebaseCloudStorage().myQuery(basis),
          itemBuilderType: PaginateBuilderType.listView,
          isLive: true,
          itemsPerPage: 10,
        ),
      ),
    );
  }
}
