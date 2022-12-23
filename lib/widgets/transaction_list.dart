import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../controllers/transactions.dart';

class TransactionList extends StatelessWidget {
  const TransactionList({super.key});

  @override
  Widget build(BuildContext context) {
    final transactions =
        Provider.of<Transactions>(context, listen: false).transactions;
    return ListView.builder(
      itemCount: transactions.length,
      itemBuilder: (context, index) => Card(
          child: ListTile(
        leading: CircleAvatar(
          // radius: 20,
          child: FittedBox(
            child: Text('${transactions[index].amount}'),
          ),
        ),
        title: Text(transactions[index].title),
        subtitle: Text(transactions[index].date.toIso8601String()),
      )),
    );
  }
}
