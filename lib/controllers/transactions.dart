import 'package:flutter/widgets.dart';

import './transaction.dart';

class Transactions with ChangeNotifier {
  List<Transaction> _transactions = [
    Transaction(
      id: DateTime.now().toString(),
      title: 'Pizza 🍕',
      amount: 2500,
      date: DateTime.now(),
    ),
    Transaction(
      id: DateTime.now().toString(),
      title: 'Eggs 🥚',
      amount: 500,
      date: DateTime.now().subtract(const Duration(days: 1)),
    ),
    Transaction(
      id: DateTime.now().toString(),
      title: 'Tomatos 🍅',
      amount: 200,
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
    Transaction(
      id: DateTime.now().toString(),
      title: 'Apples 🍎',
      amount: 300,
      date: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  // create a copy getter for the transactions
  List<Transaction> get transactions => [..._transactions];
}
