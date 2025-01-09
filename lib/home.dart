import 'package:expenses/add.dart';
import 'package:expenses/appBar.dart';
import 'package:expenses/budget.dart';
import 'package:expenses/constants.dart';
import 'package:expenses/homepageExtend.dart';
import 'package:expenses/provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/cupertino.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<String> drawerItems = ["Settings", "Share", "Help", "Logout"];
  List<IconData> icons = [
    Icons.settings,
    Icons.share,
    Icons.help,
    Icons.logout
  ];
  List<String> appbar_names = ["Budget Page", "All expenses", "Add expense"];
  int selected = 0;

  @override
  void initState() {
    super.initState();
    /////////This runs once
    context.read<ExpenseManager>().getallexpensescost();
    ///////////This widget runs once
    Future.delayed(Duration.zero, () {
      // Call to load expenses from SharedPreferences
      Provider.of<ExpenseManager>(context, listen: false)..loadExpenses();
      Provider.of<Salary>(context, listen: false).loadbudget();
      Provider.of<Salary>(context, listen: false).loadexpense();
    });
  }

  final PageController _pageController = PageController();
  int _currentIndex = 1;

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    _pageController
        .jumpToPage(index); // Directly navigates to the selected page
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appColor,
      appBar: AppBar(
        backgroundColor: appColor,
        title: Text('${appbar_names[_currentIndex]}',
            style: TextStyle(color: textColor)),
      ),
      drawer: Drawer(
        child: Column(
          children: [
            UserAccountsDrawerHeader(
              otherAccountsPictures: [
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
              accountName: Text("Abdullah Ayman"),
              accountEmail: Text("abdulluh@gmail.com"),
              currentAccountPicture: CircleAvatar(
                child: Text("Image"),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text(
                      drawerItems[index],
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    trailing: Icon(
                      icons[index],
                      color: Colors.blue,
                    ),
                    onTap: () {
                      // Add an action here, like navigation or printing
                      print("${drawerItems[index]} tapped");
                    },
                  );
                },
                itemCount: drawerItems.length,
              ),
            ),
          ],
        ),
      ),
      body: PageView(
        children: [BudgetPage(), HomePageExtend(), ExpensePage()],
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index; // Update the index when page changes
          });
        },
        physics: ScrollPhysics(),
      ),
      bottomNavigationBar: BottomNavigationBar(
        iconSize: 30,
        currentIndex: _currentIndex,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.menu_open_sharp),
            label: "",
          ),
          BottomNavigationBarItem(
            label: "",
            icon: Icon(Icons.home),
          ),
          BottomNavigationBarItem(
            label: "",
            icon: Icon(Icons.add),
          ),
        ],
        onTap: _onItemTapped,
        backgroundColor: appColor,
        fixedColor: Colors.white,
      ),
    );
  }
}
