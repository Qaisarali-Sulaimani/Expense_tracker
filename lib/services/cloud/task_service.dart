import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/services/auth/auth_service.dart';
import 'package:expense_tracker/services/cloud/task.dart';
import 'package:expense_tracker/services/cloud/task_constants.dart';

class FirebaseCloudStorage {
  static final FirebaseCloudStorage _shared =
      FirebaseCloudStorage._sharedInstance();
  FirebaseCloudStorage._sharedInstance();

  factory FirebaseCloudStorage() => _shared;

  final tasks = FirebaseFirestore.instance
      .collection('users')
      .doc(AuthService.fromFirebase().currentuser!.id)
      .collection('tasks');

  Future<Task> createNewTask() async {
    final task = await tasks.add({
      taskCName: "",
      taskCDetails: "",
      taskCDueMonth: "",
      taskCDueYear: "",
      taskCStatus: "",
    });

    return Task(
      id: task.id,
      taskName: "",
      taskDetails: "",
      year: "",
      month: "",
      isdone: false,
    );
  }

  Future<void> updateTask({
    required String id,
    required String taskName,
    required String taskDetails,
    required String year,
    required String month,
    required bool isdone,
  }) async {
    try {
      await tasks.doc(id).update({
        taskCName: taskName,
        taskCDetails: taskDetails,
        taskCDueYear: year,
        taskCDueMonth: month,
        taskCStatus: isdone,
      });
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> deleteNote({required String documentId}) async {
    try {
      await tasks.doc(documentId).delete();
    } catch (e) {
      log(e.toString());
    }
  }

  Query<Map<String, dynamic>> myQuery(String basis) {
    return tasks.orderBy(basis);
  }
}
