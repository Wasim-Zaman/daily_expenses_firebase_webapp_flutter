import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../components/date_picker.dart';
import '../controllers/transaction.dart';
import '../controllers/transactions.dart';

class AppForm extends StatefulWidget {
  bool editMode;
  String transactionId;
  AppForm({
    super.key,
    this.editMode = false,
    this.transactionId = '',
  });

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

  var initValues = {
    'id': '',
    'title': '',
    'amount': '',
    'date': 'Choose Date',
  };

  @override
  void didChangeDependencies() {
    if (widget.transactionId == '' && widget.editMode == false) {
      print('We are in adding mode');
      return;
    } else {
      print('inside else of edit mode');

      _newTransaction = Provider.of<Transactions>(context, listen: false)
          .getTransactionById(widget.transactionId);
      initValues = {
        'id': _newTransaction.id,
        'title': _newTransaction.title,
        'amount': _newTransaction.amount.toString(),
        'date': _newTransaction.date.toString(),
      };
      print(initValues);
      setState(() {});
    }
    super.didChangeDependencies();
  }

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

  Future<void> _saveForm(bool editMode) async {
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

    if (editMode == true) {
      // update
      // print('transaction updating !');
      // print("Id ======= ===== ${widget.transactionId}");
      try {
        await Provider.of<Transactions>(context, listen: false)
            .updateTransactions(widget.transactionId, _newTransaction);
        print('query ran ===================');
        Get.snackbar(
          'Updated!',
          'Transaction updated successfully',
          barBlur: 3,
          snackPosition: SnackPosition.BOTTOM,
        );
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
    } else {
      print('product added');
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
    }

    // Get.back();
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
              // decoration: const InputDecoration(labelText: "Title"),
              initialValue: initValues['title'],
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
              // decoration: const InputDecoration(labelText: "Amount"),
              initialValue: initValues['amount'],
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
                      ? widget.editMode
                          ? DateFormat.yMMMd()
                              .format(DateTime.parse(initValues['date']!))
                          : "Choose Date"
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
                _saveForm(widget.editMode);
              },
              child: const Text('Add'),
            ),
          ],
        ),
      ),
    );
  }
}
