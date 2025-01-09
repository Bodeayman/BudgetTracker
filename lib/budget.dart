import 'package:expenses/constants.dart';
import 'package:expenses/home.dart';
import 'package:expenses/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BudgetPage extends StatefulWidget {
  const BudgetPage({super.key});

  @override
  State<BudgetPage> createState() => _BudgetPageState();
}

class _BudgetPageState extends State<BudgetPage> {
  final _budgetController = new TextEditingController();
  final _totalExpesnesController = new TextEditingController();

  double budget = 0;
  double expenses = 0;
  @override
  void initState() {
    super.initState();
    // Load expenses when the page is first created
    Provider.of<Salary>(context, listen: false).loadbudget();
    Provider.of<Salary>(context, listen: false).loadexpense();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColor,
      body: Consumer<Salary>(
        builder: (context, value, child) {
          return Padding(
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Text("Your monthly Budget:"),
                Text("${value.budget}\$"),
                TextField(
                  controller: _budgetController,
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
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
                Container(
                  height: 20,
                ),
                Text("Your monthly Expenses:"),
                Text("${value.expense}\$"),
                TextField(
                  controller: _totalExpesnesController,
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
                  keyboardType:
                      const TextInputType.numberWithOptions(decimal: true),
                ),
                Container(
                  height: 10,
                ),
                MaterialButton(
                  onPressed: () {
                    double budget = value.budget;
                    double expense = value.expense;
                    try {
                      budget = double.parse(_budgetController.text);
                      expense = double.parse(_totalExpesnesController.text);
                    } catch (e) {
                      print("Error: Make all the necessary inputs");
                    }
                    value.savebudget(budget);

                    value.saveexpense(expense);
                    print("Done");
                  },
                  color: Colors.black,
                  child: Text("Submit changes",
                      style: TextStyle(color: Colors.white)),
                  elevation: 1.0,
                ),
                Container(height: 20),
                Container(
                  child: Text(
                      "Your available money is ${value.budget - value.expense}\$"),
                )
              ],
            ),
          );
        },
      ),
    );
  }
}
