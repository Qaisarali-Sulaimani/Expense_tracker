import 'package:cloud_firestore/cloud_firestore.dart';
import 'task_constants.dart';

class Task {
  final String id;
  final String taskName;
  final String taskDetails;
  final String year;
  final String month;
  final bool isdone;

  Task({
    required this.id,
    required this.taskName,
    required this.taskDetails,
    required this.year,
    required this.month,
    required this.isdone,
  });

  factory Task.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot) {
    return Task(
      id: snapshot.id,
      taskName: snapshot.data()[taskCName] as String,
      taskDetails: snapshot.data()[taskCDetails] as String,
      year: snapshot.data()[taskCDueYear] as String,
      month: snapshot.data()[taskCDueMonth] as String,
      isdone: snapshot.data()[taskCStatus] as bool,
    );
  }
}
