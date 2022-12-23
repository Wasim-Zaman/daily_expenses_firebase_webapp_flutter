import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/chart_bars.dart';
import '../controllers/transactions.dart';

class Charts extends StatelessWidget {
  const Charts({super.key});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 16 / 9,
      child: Card(
        elevation: 10,
        margin: const EdgeInsets.all(10),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Consumer<Transactions>(
            builder: (context, value, child) => Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: value.groupOfTransactionAmount.map((tx) {
                return Flexible(
                  fit: FlexFit.tight,
                  child: Consumer<Transactions>(
                    builder: (context, value, child) {
                      return ChartBars(
                        amountValue: tx['amount'] as double,
                        label: tx['day'].toString(),
                        totalAmountPercentage: value.sumOfAllSpendings == 0.0
                            ? 0.0
                            : (tx['amount'] as double) /
                                value.sumOfAllSpendings,
                      );
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
