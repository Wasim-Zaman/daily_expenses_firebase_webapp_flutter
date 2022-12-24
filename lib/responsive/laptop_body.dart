import 'package:flutter/material.dart';

import '../widgets/transaction_list.dart';
import '../widgets/app_form.dart';
import '../widgets/charts.dart';

class LaptopBody extends StatelessWidget {
  const LaptopBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Colors.pink[200],

      body: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                // 1. Charts
                Charts(),
                // 2. Transactions
                Expanded(
                  child: TransactionList(),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(30),
              child: Container(
                color: Colors.pink[200],
                width: MediaQuery.of(context).size.width * 0.4,
                child: AppForm(editMode: false, transactionId: ''),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
