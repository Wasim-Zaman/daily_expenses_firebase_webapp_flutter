import 'package:flutter/material.dart';

import '../widgets/transaction_list.dart';
import '../widgets/app_form.dart';

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
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: AspectRatio(
              aspectRatio: 16 / 9,
              child: Container(
                height: MediaQuery.of(context).size.height * 0.40,
                width: MediaQuery.of(context).size.width * 0.40,
                color: Colors.pink[300],
                child: Text('Carts'),
              ),
            ),
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
