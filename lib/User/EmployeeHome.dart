import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Company.dart';
import 'CompanyHomeScreen.dart';
import 'EmployeeHomeScreen.dart';

import 'Employee.dart';

class EmployeeHome extends StatefulWidget {
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
    final Employee employee = Provider.of<Employee>(context);
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
      body: employee == null
          ? Center(child: CircularProgressIndicator())
          : PageView(
              onPageChanged: (index) => setState(() {
                _currentIndex = index;
              }),
              controller: _controller,
              children: [
                StreamProvider.value(
                  value: Company(uid: employee.companyUid ?? null).self,
                  child: CompanyHomeScreen(),
                ),
                EmployeeHomeScreen(),
                Center(
                  child: Text("This is company list screen"),
                ),
              ],
            ),
    );
  }
}
