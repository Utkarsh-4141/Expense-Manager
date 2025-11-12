import "package:flutter/material.dart";

class TransactionDemo extends ChangeNotifier {
  List<Map<String, dynamic>> transactionList;

  TransactionDemo({required this.transactionList, trashList});

  void changeTransactionData(List<Map<String, dynamic>> transactionList) {
    this.transactionList = transactionList;
    notifyListeners();
  }

  void addTransaction(Map<String, dynamic> newTransaction) {
    transactionList.add(newTransaction);
    notifyListeners();
  }
}