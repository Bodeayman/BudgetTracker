import 'package:expenses/add.dart';
import 'package:expenses/home.dart';
import 'package:expenses/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(
        create: (context) => ExpenseManager(),
      ),
      ChangeNotifierProvider(
        create: (context) => Salary(),
      ),
    ],
    // Providing the ExpenseList provider
    child: MainApp(),
  ));
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: []);
    return MaterialApp(
      theme: ThemeData(
        textTheme: TextTheme(
          bodyMedium: TextStyle(color: Colors.white, fontSize: 20),
        ),
      ),
      home: HomePage(),
      debugShowCheckedModeBanner: false,
    );
  }
}
