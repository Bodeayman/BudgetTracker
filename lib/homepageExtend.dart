import 'package:expenses/constants.dart';
import 'package:expenses/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePageExtend extends StatefulWidget {
  const HomePageExtend({super.key});

  @override
  State<HomePageExtend> createState() => _HomePageExtendState();
}

class _HomePageExtendState extends State<HomePageExtend> {
  double passedexpenses = 0;
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Consumer<ExpenseManager>(
        builder: (context, value, child) {
          double passedexpenses = value.totalExpenses;
          if (value.expenses.isEmpty) {
            return Center(
              child:
                  Text("No Expenses found", style: TextStyle(color: textColor)),
            );
          }

          print(value.totalExpenses);
          return Column(
            children: [
              Padding(
                padding: EdgeInsets.all(5),
                child: Text("Expenses",
                    style: TextStyle(fontSize: 22, color: textColor)),
              ),
              Consumer<Salary>(
                builder: (context, value, child) {
                  return Padding(
                      padding: EdgeInsets.all(2),
                      child: Text(
                        "Your net budget is ${value.budget - value.expense}\$",
                      ));
                },
              ),
              Consumer<Salary>(
                builder: (context, value, child) {
                  return Padding(
                      padding: EdgeInsets.all(2),
                      child: Text(
                        "The remaining  is ${value.budget - value.expense - passedexpenses}\$",
                      ));
                },
              ),
              GridView.builder(
                shrinkWrap:
                    true, // Ensures the grid takes up only as much space as needed
                physics:
                    NeverScrollableScrollPhysics(), // Prevents scroll conflicts with the parent
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // Two columns in the grid
                  crossAxisSpacing: 9, // Space between columns
                  mainAxisSpacing: 9, // Space between rows
                  childAspectRatio: 1, // Aspect ratio of each grid item
                ),
                itemCount: value.expenses.length,
                itemBuilder: (context, index) {
                  return InkWell(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: Colors.black,
                              title: Text("Expense Details",
                                  style: TextStyle(color: Colors.white)),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "Date: ${value.expenses[index].date.substring(0, 10)}",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "Amount: ${value.expenses[index].amount}\$",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    "Description: ${value.expenses[index].description}",
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text('Close'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: Card(
                        color: Colors.black, // Background color of grid items
                        elevation: 5,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Expense ${index + 1}",
                                style:
                                    TextStyle(fontSize: 14, color: textColor),
                              ),
                              SizedBox(height: 3),
                              Text(
                                "Date: ${value.expenses[index].date.substring(0, 10)}",
                                style:
                                    TextStyle(fontSize: 12, color: textColor),
                              ),
                              SizedBox(height: 3),
                              Text(
                                "Amount: ${value.expenses[index].amount}\$",
                                style:
                                    TextStyle(fontSize: 14, color: textColor),
                              ),
                              SizedBox(height: 5),
                              Text(
                                "Description: ${value.expenses[index].description}",
                                style:
                                    TextStyle(fontSize: 12, color: textColor),
                                overflow: TextOverflow.ellipsis,
                              ),
                              Spacer(),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  value.removeExpense(value.expenses[index]);
                                  context
                                      .read<ExpenseManager>()
                                      .getallexpensescost();
                                },
                              ),
                            ],
                          ),
                        ),
                      ));
                },
              ),
            ],
          );
        },
      ),
    );
  }
}
