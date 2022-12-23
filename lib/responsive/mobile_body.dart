import 'package:flutter/material.dart';

import '../widgets/transaction_list.dart';
import '../widgets/app_form.dart';
import '../widgets/charts.dart';

class MobileBody extends StatelessWidget {
  const MobileBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (ctx) {
              return const AppForm();
            },
          );
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(),
      backgroundColor: Colors.pink[200],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // 1. Charts
          Container(
            child: Charts(),
          ),

          // 2. Transactions
          const Expanded(
            child: TransactionList(),
          )
        ],
      ),
    );
  }
}
