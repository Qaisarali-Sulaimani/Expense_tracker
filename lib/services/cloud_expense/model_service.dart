import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/services/auth/auth_service.dart';
import 'package:expense_tracker/services/cloud_expense/model.dart';
import 'package:expense_tracker/services/cloud_expense/model_constant.dart';

class FirebaseCloudStorageExpense {
  static final FirebaseCloudStorageExpense _shared =
      FirebaseCloudStorageExpense._sharedInstance();
  FirebaseCloudStorageExpense._sharedInstance();

  factory FirebaseCloudStorageExpense() => _shared;

  final transactions = FirebaseFirestore.instance
      .collection('users')
      .doc(AuthService.fromFirebase().currentuser!.id)
      .collection('expense_tracker');

  Future<TransactionModel> createNewTransaction() async {
    final transaction = await transactions.add({
      myDetails: "",
      myAmount: 0,
      myType: 0,
    });

    return TransactionModel(
      amount: 0,
      isAdd: false,
      details: "",
      id: transaction.id,
    );
  }

  Future<void> updateTransaction({
    required int amount,
    required String details,
    required bool isAdd,
    required String id,
  }) async {
    try {
      await transactions.doc(id).update({
        myDetails: details,
        myAmount: amount,
        myType: isAdd,
      });
      await totalExpenditure();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> deleteTransaction({required String documentId}) async {
    try {
      await transactions.doc(documentId).delete();
      await totalExpenditure();
    } catch (e) {
      log(e.toString());
    }
  }

  Future<Map<String, int>> totalExpenditure() async {
    int totalAdd = 0;
    int totalSub = 0;
    int total = 0;
    await transactions.get().then((querySnapshot) {
      for (var result in querySnapshot.docs) {
        result[myType] as bool == true
            ? totalAdd += result[myAmount] as int
            : totalSub += result[myAmount] as int;
      }
    });
    total = totalAdd - totalSub;

    return {
      "add": totalAdd,
      "sub": totalSub,
      "tot": total,
    };
  }

  Future<Map<String, double>> getAll(bool isTrue) async {
    final task = await transactions.get();
    Map<String, double> done = {};
    for (var i in task.docs) {
      String s = i[myDetails] as String;
      int val = i[myAmount] as int;

      if (i[myType] as bool == isTrue) {
        done[s] = val.toDouble();
      }
    }

    return done;
  }

  Query<Map<String, dynamic>> myQuery(String s) {
    return transactions.orderBy(s);
  }
}
