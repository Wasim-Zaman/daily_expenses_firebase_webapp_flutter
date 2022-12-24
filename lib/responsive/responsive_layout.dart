import 'package:flutter/material.dart';

import './laptop_body.dart';
import './mobile_body.dart';

// CONSTANTS
const mobileWidth = 500;

class ResponsiveLayout extends StatelessWidget {
  final Widget mobileBody;
  final Widget laptopBody;
  const ResponsiveLayout({
    super.key,
    required this.mobileBody,
    required this.laptopBody,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Daily Expenses'),
      ),
      body: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth <= mobileWidth) {
          return const MobileBody();
        } else {
          return const LaptopBody();
        }
      }),
    );
  }
}
