import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:provider/provider.dart';

import '../controllers/transactions.dart';

class TransactionList extends StatefulWidget {
  const TransactionList({super.key});

  @override
  State<TransactionList> createState() => _TransactionListState();
}

class _TransactionListState extends State<TransactionList> {
  Future? transactionFetch;
  Future getFuture() => Provider.of<Transactions>(context, listen: false)
      .fetchAndSetTransactions();

  @override
  void initState() {
    transactionFetch = getFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: transactionFetch,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else {
            if (snapshot.error != null) {
              return const Center(
                child: Text('Something went wrong!'),
              );
            } else {
              return Consumer<Transactions>(
                builder: (_, transactionsInfo, child) {
                  print(transactionsInfo.transactions);
                  return ListView.builder(
                    itemCount: transactionsInfo.transactions.length,
                    itemBuilder: (context, index) => Card(
                        child: ListTile(
                      leading: CircleAvatar(
                        // radius: 20,
                        child: FittedBox(
                          child: Text(
                              '${transactionsInfo.transactions[index].amount}'),
                        ),
                      ),
                      title: Text(transactionsInfo.transactions[index].title),
                      subtitle: Text(
                        DateFormat.yMMMMd()
                            .format(transactionsInfo.transactions[index].date),
                      ),
                    )),
                  );
                },
              );
            }
          }
        });
  }
}
