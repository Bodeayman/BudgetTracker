import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // To encode/decode JSON

class Expenses {
  String date;
  String description;
  double amount;

  Expenses(
      {required this.date, required this.description, required this.amount});

  // Convert an Expenses object to a Map (JSON format)
  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'description': description,
      'amount': amount,
    };
  }

  // Create an Expenses object from a Map (JSON format)
  factory Expenses.fromJson(Map<String, dynamic> json) {
    return Expenses(
      date: json['date'] ?? '', // Default to empty string if date is missing
      description: json['description'] ??
          '', // Default to empty string if description is missing
      amount: json['amount'] is double
          ? json['amount']
          : 0.0, // Ensure amount is a double
    );
  }
}

class Salary extends ChangeNotifier {
  double _budget = 0;
  double get budget => _budget;
  double _expense = 0;
  double get expense => _expense;
  void recalculateBudget(double totalExpenses) {
    // Trigger a recalculation and UI update
    notifyListeners();
  }

  Future<void> loadbudget() async {
    final prefs = await SharedPreferences.getInstance();
    final Savedbudget = prefs.getString('budget');
    if (Savedbudget != null) {
      // Convert the string to a double and update _budget
      _budget = double.tryParse(Savedbudget) ??
          0.0; // Default to 0.0 if conversion fails
    } else {
      _budget = 0.0; // If no value found in SharedPreferences, set it to 0.0
    }
    notifyListeners();
  }

  Future<void> savebudget(double budget) async {
    _budget = budget;
    final prefs = await SharedPreferences.getInstance();
    try {
      await prefs.setString('budget', _budget.toString());
    } catch (e) {
      prefs.setString('budget', "0");
    }
    notifyListeners();
  }

  Future<void> loadexpense() async {
    final prefs = await SharedPreferences.getInstance();
    final SavedExpense = await prefs.getString("expense");

    if (SavedExpense != null) {
      _expense = double.tryParse(SavedExpense) ?? 0.0;
    } else {
      _expense = 0;
    }

    notifyListeners();
  }

  Future<void> saveexpense(double expense) async {
    _expense = expense;
    final prefs = await SharedPreferences.getInstance();
    try {
      await prefs.setString('expense', _expense.toString());
    } catch (e) {
      prefs.setString('expense', "0");
    }
    notifyListeners();
  }
}

class ExpenseManager extends ChangeNotifier {
  List<Expenses> _expenses = []; // Initialized as an empty list

  List<Expenses> get expenses => _expenses;
  double totalExpenses = 0;
  // Load expenses from SharedPreferences
  Future<void> loadExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    final expensesJson = prefs.getString('expenses') ??
        '[]'; // Default to an empty list if no data is found

    try {
      final List<dynamic> expensesList = jsonDecode(expensesJson);
      _expenses = expensesList.map((item) => Expenses.fromJson(item)).toList();
    } catch (e) {
      // Handle the case where the JSON decoding fails
      print("Error decoding expenses data: $e");
      _expenses = []; // Reset to an empty list if there's an error
    }
    notifyListeners();
  }

  // Save expenses to SharedPreferences
  Future<void> saveExpenses() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final expensesJson =
          jsonEncode(_expenses.map((e) => e.toJson()).toList());
      await prefs.setString('expenses', expensesJson);
    } catch (e) {
      // Handle any errors that might occur during saving
      print("Error saving expenses: $e");
    }
    notifyListeners();
  }

  Future<void> addExpense(Expenses expense) async {
    _expenses.add(expense);
    await saveExpenses();
    notifyListeners();
  }

  Future<void> removeExpense(Expenses expense) async {
    _expenses.remove(expense);
    await saveExpenses();
    notifyListeners();
  }

  Future<void> clearAllExpenses() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('expenses');
    _expenses.clear(); // Clear the in-memory list as well
    notifyListeners(); // Notify listeners to update the UI
    print('All expenses deleted.');
  }

  Future<void> getallexpensescost() async {
    await loadExpenses();

    totalExpenses = _expenses.fold(0.0, (sum, expense) => sum + expense.amount);
    print("Total Expenses: $totalExpenses");

    notifyListeners();
  }
}
