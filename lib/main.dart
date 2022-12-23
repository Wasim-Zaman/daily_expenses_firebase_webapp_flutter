import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';

import './responsive/responsive_layout.dart';
import './responsive/mobile_body.dart';
import './responsive/laptop_body.dart';

import './controllers/transactions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => Transactions(),
      child: GetMaterialApp(
        theme: ThemeData(primarySwatch: Colors.pink),
        debugShowCheckedModeBanner: false,
        initialRoute: '/',
        getPages: [
          GetPage(
            name: '/',
            page: () => const ResponsiveLayout(
              mobileBody: MobileBody(),
              laptopBody: LaptopBody(),
            ),
          ),
        ],
      ),
    );
  }
}
