import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;

import './transaction.dart';

class Transactions with ChangeNotifier {
  List<Transaction> _transactions = [
    // Transaction(
    //   id: DateTime.now().toString(),
    //   title: 'Pizza 🍕',
    //   amount: 2500,
    //   date: DateTime.now(),
    // ),
    // Transaction(
    //   id: DateTime.now().toString(),
    //   title: 'Eggs 🥚',
    //   amount: 500,
    //   date: DateTime.now().subtract(const Duration(days: 1)),
    // ),
    // Transaction(
    //   id: DateTime.now().toString(),
    //   title: 'Tomatos 🍅',
    //   amount: 200,
    //   date: DateTime.now().subtract(const Duration(days: 2)),
    // ),
    // Transaction(
    //   id: DateTime.now().toString(),
    //   title: 'Apples 🍎',
    //   amount: 300,
    //   date: DateTime.now().subtract(const Duration(days: 3)),
    // ),
  ];

  // create a copy getter for the transactions
  List<Transaction> get transactions => [..._transactions];

  // Adding new transactions to the list of transaction
  Future<void> addNewTransaction(Transaction newTransaction) async {
    const url =
        'https://daily-expenses-4adf8-default-rtdb.firebaseio.com/transactions.json';

    try {
      final response = await http.post(Uri.parse(url),
          body: json.encode({
            'id': newTransaction.id,
            'title': newTransaction.title,
            'amount': newTransaction.amount,
            'date': newTransaction.date.toIso8601String(),
          }));
      newTransaction = Transaction(
        id: json.decode(response.body)['name'],
        amount: newTransaction.amount,
        title: newTransaction.title,
        date: newTransaction.date,
      );
      _transactions.insert(0, newTransaction);
      // print('product added to the firebase');
      print(json.decode(response.body)['name']);
      notifyListeners();
    } catch (error) {
      print('Inside catch block of add transaction');
      rethrow;
    }
  }

  Future<void> fetchAndSetTransactions() async {
    const url =
        'https://daily-expenses-4adf8-default-rtdb.firebaseio.com/transactions.json';

    try {
      final response = await http.get(Uri.parse(url));
      final List<Transaction> listOfLoadedTransactions = [];
      // checking the type of the response.
      print("Body = = = ${json.decode(response.body)}");

      if (json.decode(response.body) == null) {
        throw Exception('No transaction found');
      }
      final responseBody = json.decode(response.body) as Map<String, dynamic>;
      responseBody.forEach((productId, transactionData) {
        final Transaction newTransaction = Transaction(
          id: productId,
          title: transactionData['title'],
          amount: transactionData['amount'],
          date: DateTime.parse(transactionData['date']),
        );
        listOfLoadedTransactions.add(newTransaction);
      });
      _transactions = listOfLoadedTransactions;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }
}
