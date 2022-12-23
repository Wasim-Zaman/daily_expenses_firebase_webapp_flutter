import 'package:flutter/material.dart';

Future<DateTime?> appDatePicker(BuildContext context) async {
  return showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime(2014),
    lastDate: DateTime.now(),
  );
}
