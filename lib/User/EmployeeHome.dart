import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rankless/shared/Interface.dart';
import 'package:rankless/shared/keepAliveThis.dart';
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
  PageController _controller = PageController();
  List<Widget> _screens = [
    KeepAliveThis(child: CompanyHomeScreen()),
    KeepAliveThis(child: EmployeeHomeScreen()),
    KeepAliveThis(
      child: Container(
        decoration: backgroundDecoration,
        child: Center(
          child: Text(
            "Coming soon...",
            style: titleNameStyle.copyWith(fontWeight: FontWeight.normal),
          ),
        ),
      ),
    ),
  ];

  @override
  void initState() {
    _controller = PageController(initialPage: _currentIndex);
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
        selectedLabelStyle: TextStyle(fontFamily: font, color: Colors.white),
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
          _controller.animateToPage(index, duration: Duration(milliseconds: 200), curve: Curves.ease);
        }),
      ),
      body: Container(
        decoration: backgroundDecoration,
        child: (employee == null
            ? loader
            : StreamProvider<Company>.value(
                initialData: null,
                updateShouldNotify: (a, b) => true,
                value: employee.companyUid == null ? null : Company(uid: employee.companyUid).self,
                child: PageView(
                  onPageChanged: (index) => setState(() {
                    _currentIndex = index;
                  }),
                  controller: _controller,
                  children: _screens,
                ),
              )),
      ),
    );
  }
}
