import 'package:expenses/constants.dart';
import 'package:expenses/home.dart';
import 'package:expenses/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'dart:math';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: ExpensePage(),
    );
  }
}

class ExpensePage extends StatefulWidget {
  const ExpensePage({super.key});

  @override
  _ExpensePageState createState() => _ExpensePageState();
}

class _ExpensePageState extends State<ExpensePage> {
  final _expenseController =
      TextEditingController(); // Controller for the TextField
  String warning = "";
  String _expenseString = ''; // To hold the entered expense value
  String _expenseAmount = '';
  final _expenseAmountController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Load expenses when the page is first created
    Provider.of<ExpenseManager>(context, listen: false).loadExpenses();
  }

  // Function to show the custom SnackBar
  void _showCustomSnackBar(BuildContext context) {
    final snackBar = SnackBar(
      content: Text(
        warning,
        style: const TextStyle(color: Colors.white), // White text color
      ),
      backgroundColor: Colors.black, // Black background color
      duration:
          const Duration(seconds: 3), // Duration for which SnackBar is visible
      behavior: SnackBarBehavior
          .floating, // Make it floating (not anchored at the bottom)
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10), // Rounded corners
      ),
      margin: const EdgeInsets.all(16), // Margin from edges
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar); // Show the SnackBar
  }

  final _focusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColor,
      body: Consumer<ExpenseManager>(
        // Consumer widget to listen to changes in ExpenseList
        builder: (context, value, child) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Text asking for expense input
                Text(
                  'What is your expense today?',
                  style: TextStyle(fontSize: 18, color: textColor),
                ),
                const SizedBox(height: 20),

                // TextField to input expense amount
                TextField(
                  controller: _expenseController,
                  style: TextStyle(color: Colors.white),

                  decoration: InputDecoration(
                    labelText: 'Enter Expense',
                    labelStyle: TextStyle(color: textColor),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: appColor,
                        width: 2.0, // Thickness of the border
                        style:
                            BorderStyle.solid, // You can also use dotted, etc.
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 2.0, // Thickness of the border
                        style:
                            BorderStyle.solid, // You can also use dotted, etc.
                      ),
                    ),
                  ),
                  cursorColor: Colors.white,

                  // Allow decimal input
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _expenseAmountController,
                  style: TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Enter The amount',
                    labelStyle: TextStyle(color: textColor),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: appColor,
                        width: 2.0, // Thickness of the border
                        style:
                            BorderStyle.solid, // You can also use dotted, etc.
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(
                        color: Colors.black,
                        width: 2.0, // Thickness of the border
                        style:
                            BorderStyle.solid, // You can also use dotted, etc.
                      ),
                    ),
                  ),
                  cursorColor: Colors.white,
                  keyboardType: const TextInputType.numberWithOptions(
                      decimal: true), // Allow decimal input
                ),
                const SizedBox(height: 20),

                ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all(
                        Colors.black), // Corrected ButtonStyle
                  ),
                  onPressed: () async {
                    setState(() {
                      _expenseString = _expenseController.text;
                      _expenseAmount = _expenseAmountController.text;
                    });

                    if (_expenseString.isNotEmpty ||
                        !_expenseAmount.isNotEmpty) {
                      String expenseDate = DateTime.now().toIso8601String();
                      String _expenseAmount = _expenseAmountController.text;
                      String _expenseString = _expenseController.text;
                      double amountD = 0;
                      try {
                        amountD = double.parse(_expenseAmount);
                      } catch (e) {
                        warning = "Invalid Amount";
                        _showCustomSnackBar(context);
                      }
                      Expenses expense = new Expenses(
                          amount: amountD,
                          date: expenseDate,
                          description: _expenseString);
                      FocusScope.of(context).unfocus();
                      value.addExpense(expense);
                      warning = "Added the expense";
                      await value.getallexpensescost();

                      _expenseController.clear();
                      _expenseAmountController.clear();
                    } else {
                      warning = "The input is empty";
                      _showCustomSnackBar(
                          context); // Show custom SnackBar for empty input
                    }

                    // Optionally, show a SnackBar here for the entered expense
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                          content: Text('Expense entered: \$$_expenseAmount')),
                    );
                  },
                  child: Text(
                    'Submit Expense',
                    style: TextStyle(color: textColor),
                  ),
                ),

                // Display the entered expense
                Text(
                  'You entered: \$$_expenseAmount',
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: textColor),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
