import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rankless/Company.dart';
import 'package:rankless/CompanyHomeScreen.dart';
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
  String message = '';
  int _currentIndex = 1;
  Company company;
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
              ) {
            print(snapshot.toString());
            return Center(child: CircularProgressIndicator());
          } else {
            _screens = [
              //TODO maknuti loading prilikom svakog ulaska na ovaj dio ekrana
              FutureBuilder(
                  future: widget.employee.getCompanyData(),
                  initialData: this.company,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done ||
                        snapshot.hasData) {
                      this.company = widget.employee.company;
                      if (this.company == null)
                        return CircularProgressIndicator();
                      return CompanyHomeScreen(this.company);
                    } else
                      return Center(child: CircularProgressIndicator());
                  }),
              EmployeeHomeScreen(widget.employee),
              Center(
                child: Text("This is company list screen"),
              ),
            ];
            return _screens[_currentIndex];
          }
        },
      ),
    );
  }
}
