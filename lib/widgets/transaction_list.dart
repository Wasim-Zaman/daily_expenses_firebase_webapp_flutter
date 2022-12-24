import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../widgets/app_form.dart';
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
                      elevation: 6,
                      color: Colors.pink[100],
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
                          DateFormat.yMMMMd().format(
                              transactionsInfo.transactions[index].date),
                        ),
                        trailing: Container(
                          width: MediaQuery.of(context).size.width * 0.20,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              IconButton(
                                onPressed: () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) {
                                      return AlertDialog(
                                        actions: [
                                          AppForm(
                                            editMode: true,
                                            transactionId: transactionsInfo
                                                .transactions[index].id,
                                          )
                                        ],
                                      );
                                    },
                                  );
                                },
                                icon: const Icon(Icons.edit),
                              ),
                              IconButton(
                                onPressed: () async {
                                  try {
                                    await Provider.of<Transactions>(context,
                                            listen: false)
                                        .deleteTransaction(transactionsInfo
                                            .transactions[index].id);
                                    Get.snackbar('Deleted',
                                        'Transaction successfully deleted');
                                  } catch (error) {
                                    Get.snackbar('Error', error.toString());
                                  }
                                },
                                icon: Icon(
                                  Icons.delete,
                                  color: Theme.of(context).errorColor,
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              );
            }
          }
        });
  }
}
