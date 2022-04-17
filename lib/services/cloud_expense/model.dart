import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:expense_tracker/services/cloud_expense/model_constant.dart';

class TransactionModel {
  final String id;
  final int amount;
  final bool isAdd;
  final String details;

  TransactionModel({
    required this.amount,
    required this.isAdd,
    required this.details,
    required this.id,
  });

  factory TransactionModel.fromSnapshot(
      QueryDocumentSnapshot<Map<String, dynamic>> snapshot) {
    return TransactionModel(
      id: snapshot.id,
      amount: snapshot.data()[myAmount] as int,
      details: snapshot.data()[myDetails] as String,
      isAdd: snapshot.data()[myType] as bool,
    );
  }
}
