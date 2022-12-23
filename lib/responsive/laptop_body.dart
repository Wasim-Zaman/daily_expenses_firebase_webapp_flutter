import 'package:flutter/material.dart';

import '../widgets/transaction_list.dart';
import '../widgets/app_form.dart';
import '../widgets/charts.dart';

class LaptopBody extends StatelessWidget {
  const LaptopBody({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[200],
      appBar: AppBar(),
      body: Row(
        children: [
          Expanded(
            child: Column(
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
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: Container(
                color: Colors.pink[300],
                width: MediaQuery.of(context).size.width * 0.4,
                child: const AppForm(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
