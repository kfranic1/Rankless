import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rankless/shared/Interface.dart';
import 'Company.dart';
import 'CompanyHomeScreen.dart';
import 'EmployeeHomeScreen.dart';

import 'Employee.dart';

class EmployeeHome extends StatefulWidget {
  @override
  _EmployeeHomeState createState() => _EmployeeHomeState();
}

class _EmployeeHomeState extends State<EmployeeHome> {
  String message = '';
  int _currentIndex = 1;
  PageController _controller;

  @override
  void initState() {
    _controller = PageController(initialPage: _currentIndex, keepPage: true);
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Employee employee = Provider.of<Employee>(context);
    final Company company = Provider.of<Company>(context);
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.shifting,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.indigo,
            label: "Company",
            icon: Icon(Icons.account_balance),
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.indigo,
            label: 'Profile',
            icon: Icon(Icons.person),
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.indigo,
            label: 'Company List',
            icon: Icon(Icons.list),
          ),
        ],
        onTap: (index) => setState(() {
          print(index);
          _currentIndex = index;
          _controller.animateToPage(index,
              duration: Duration(milliseconds: 200), curve: Curves.ease);
        }),
      ),
      body: (employee == null || company == null)
          ? loader
          : PageView(
              onPageChanged: (index) => setState(() {
                _currentIndex = index;
              }),
              controller: _controller,
              children: [
                CompanyHomeScreen(),
                EmployeeHomeScreen(),
                Center(
                  child: Text("This is company list screen"),
                ),
              ],
            ),
    );
  }
}
