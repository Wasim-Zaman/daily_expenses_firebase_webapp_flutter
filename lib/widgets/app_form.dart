import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../components/date_picker.dart';
import '../controllers/transaction.dart';
import '../controllers/transactions.dart';

class AppForm extends StatefulWidget {
  const AppForm({super.key});

  @override
  State<AppForm> createState() => _AppFormState();
}

class _AppFormState extends State<AppForm> {
  final FocusNode _amountNode = FocusNode();
  final _formKey = GlobalKey<FormState>();
  DateTime? dateValue;
  var _newTransaction = Transaction(
    id: '',
    title: '',
    amount: 0,
    date: DateTime(0),
  );

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    _amountNode.dispose();
    // _formKey.currentState!.dispose();
    super.dispose();
  }

  Future<void> _saveForm() async {
    // in order to save the form, we need access to the form widget,
    // for that we will need Global Key to access or interact with the form.
    final isValid = _formKey.currentState!.validate();
    if (!isValid) {
      // ScaffoldMessenger.of(context)
      //     .showSnackBar(SnackBar(content: Text('Error')));
      print('invalid');
      return;
      // do not let the below code to be executed if form is not valid
      // for every text form field.
    }
    _formKey.currentState!.save();

    try {
      print('inside try');
      await Provider.of<Transactions>(context, listen: false)
          .addNewTransaction(_newTransaction);
    } catch (error) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          icon: const Icon(Icons.error),
          title: const Text('Error'),
          content: const Text("Something went wrong!"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Ok'),
            ),
          ],
        ),
      );
    }

    // Get.back();
  }

  @override
  Widget build(BuildContext context) {
    final transactionData =
        Provider.of<Transactions>(context, listen: false).transactions;
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
              textInputAction: TextInputAction.next,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Kindly provide value to the field';
                }
                return null;
              },
              onFieldSubmitted: (value) {
                FocusScope.of(context).requestFocus(_amountNode);
              },
              onSaved: (newValue) {
                _newTransaction = Transaction(
                  id: _newTransaction.id,
                  title: newValue!,
                  amount: _newTransaction.amount,
                  date: _newTransaction.date,
                );
              },
            ),
            TextFormField(
              decoration: const InputDecoration(labelText: "Amount"),
              focusNode: _amountNode,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Kindly provide value to the field';
                }
                if (double.tryParse(value) == null) {
                  return 'Kindly Provide Numeric Value Only';
                }
                if (double.parse(value) <= 0) {
                  return "Please enter a price greater then zero";
                }
                return null;
              },
              onSaved: (newValue) {
                _newTransaction = Transaction(
                  id: _newTransaction.id,
                  title: _newTransaction.title,
                  amount: double.parse(newValue!),
                  date: _newTransaction.date,
                );
              },
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  dateValue == null
                      ? "Choose Date"
                      : DateFormat.yMMMd().format(dateValue!),
                ),
                TextButton(
                  onPressed: () async {
                    dateValue = await appDatePicker(context);
                    _newTransaction = Transaction(
                      id: _newTransaction.id,
                      title: _newTransaction.title,
                      amount: _newTransaction.amount,
                      date: dateValue!,
                    );
                    setState(() {});
                  },
                  child: const Text('Date Picker'),
                ),
              ],
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.05,
            ),
            ElevatedButton(
              onPressed: () {
                _saveForm();
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
