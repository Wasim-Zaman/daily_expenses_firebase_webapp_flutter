import 'package:flutter/material.dart';

import '../components/date_picker.dart';

class AppForm extends StatefulWidget {
  const AppForm({super.key});

  @override
  State<AppForm> createState() => _AppFormState();
}

class _AppFormState extends State<AppForm> {
  final FocusNode _amountNode = FocusNode();
  final _formKey = GlobalKey();
  DateTime? dateValue;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _amountNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            const Center(
              child: Text(
                'Add Transactions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: "Title"),
              keyboardType: TextInputType.text,
              textInputAction: TextInputAction.next,
              validator: (value) {
                return null;
              },
              onFieldSubmitted: (value) {
                FocusScope.of(context).requestFocus(_amountNode);
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: "Amount"),
              keyboardType: TextInputType.number,
              focusNode: _amountNode,
              validator: (value) {
                return null;
              },
            ),
            TextButton(
                onPressed: () async {
                  dateValue = await appDatePicker(context);
                },
                child: Text('date picker'))
          ],
        ),
      ),
    );
  }
}
