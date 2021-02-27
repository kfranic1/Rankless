import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rankless/Company.dart';
import 'package:rankless/CompanyHomeScreen.dart';
import 'package:rankless/custom_app_bar.dart';
import 'EmployeeHomeScreen.dart';

import 'Employee.dart';

class EmployeeHome extends StatefulWidget {
  final Employee employee;
  final Company company;
  EmployeeHome(this.employee, this.company);
  //Pazi employee moze biti guest to provjeravas sa employee.anonymus TODO
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
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.shifting,
        items: [
          BottomNavigationBarItem(
            backgroundColor: Colors.blue,
            label: "Company",
            icon: Icon(Icons.account_balance),
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.blue,
            label: 'Profile',
            icon: Icon(Icons.person),
          ),
          BottomNavigationBarItem(
            backgroundColor: Colors.blue,
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
      body: PageView(
        onPageChanged: (index) => setState(() {
          _currentIndex = index;
        }),
        controller: _controller,
        children: [
          widget.company == null
              ? Text("You are not in any company")
              : CompanyHomeScreen(widget.company),
          EmployeeHomeScreen(widget.employee),
          Center(
            child: Text("This is company list screen"),
          ),
        ],
      ),
    );
  }
}
