import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rankless/custom_app_bar.dart';
import 'EmployeeHomeScreen.dart';

import 'Employee.dart';

class EmployeeHome extends StatefulWidget {
  final Employee employee;
  EmployeeHome(this.employee);
  //Pazi employee moze biti guest to provjeravas sa employee.anonymus TODO
  @override
  _EmployeeHomeState createState() => _EmployeeHomeState();
}

class _EmployeeHomeState extends State<EmployeeHome> {
  List<Widget> _screens;
  bool loading = true;
  String message = '';
  int _currentIndex = 1;
  //0 - user with comapny / 1 - user with no company / 2 - guest

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
        onTap: (index) => setState(() => _currentIndex = index),
      ),
      body: StreamBuilder(
        stream: widget.employee.self,
        builder: (context, snapshot) {
          if (!snapshot
                  .hasData /*||
              snapshot.connectionState != ConnectionState.active*/
              )
            return Center(child: CircularProgressIndicator());
          else {
            _screens = [
              Center(
                child: Text("This is company screen"),
              ),
              EmployeeHomeScreen(widget.employee),
              Center(
                child: Text('This is company list'),
              ),
            ];
            return _screens[_currentIndex];
          }
        },
      ),
    );
  }
}
