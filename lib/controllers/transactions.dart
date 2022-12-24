import 'dart:convert';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

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

  List<Transaction> get _lastWeekTransactions {
    return _transactions.where((tx) {
      return tx.date.isAfter(
        DateTime.now().subtract(const Duration(days: 7)),
      );
    }).toList();
  }

  List<Map<String, Object>> get groupOfTransactionAmount {
    var lastWeekTransactions = _lastWeekTransactions;
    return List.generate(7, (index) {
      final weekDays = DateTime.now().subtract(Duration(days: index));
      var totalAmount = 0.0;

      for (var tx in lastWeekTransactions) {
        if (weekDays.day == tx.date.day &&
            weekDays.month == tx.date.month &&
            weekDays.year == tx.date.year) {
          totalAmount += tx.amount;
        }
      }
      return {
        'day': DateFormat.E().format(weekDays).substring(0, 1),
        'amount': totalAmount,
      };
    }).reversed.toList();
  }

  double get sumOfAllSpendings {
    return groupOfTransactionAmount.fold(0.0, (previousValue, element) {
      return previousValue + (element['amount'] as double);
    });
  }

  Transaction getTransactionById(String id) {
    return _transactions.firstWhere((tx) => tx.id == id);
  }

  Future<void> updateTransactions(String id, Transaction transaction) async {
    final transactionIndex = _transactions.indexWhere((tx) => tx.id == id);
    print("Transaction index ====== ${transactionIndex}");

    if (transactionIndex >= 0) {
      final url =
          'https://daily-expenses-4adf8-default-rtdb.firebaseio.com/transactions/$id.json';
      await http.patch(
        Uri.parse(url),
        body: json.encode(
          {
            "title": transaction.title,
            "amount": transaction.amount,
            "date": transaction.date.toIso8601String(),
          },
        ),
      );
      _transactions[transactionIndex] = transaction;
      notifyListeners();
    } else {
      // print('Item not found');
    }
  }

  Future<void> deleteTransaction(String id) async {
    final url =
        'https://daily-expenses-4adf8-default-rtdb.firebaseio.com/transactions/$id.json';
    final transactionIndex = _transactions.indexWhere((tx) => tx.id == id);
    Transaction? deletedTransaction = _transactions.elementAt(transactionIndex);

    _transactions.removeAt(transactionIndex);
    notifyListeners();

    try {
      final response = await http.delete(Uri.parse(url));
      print("The response status code is: '${response.statusCode}'");
      if (response.statusCode >= 400) {
        _transactions.insert(transactionIndex, deletedTransaction);
        notifyListeners();
        throw Exception('Product could not be deleted!');
      }
      print('product deleted successfully');
      deletedTransaction = null;
    } catch (error) {
      print('internet problem');
      rethrow;
    }
  }
}
