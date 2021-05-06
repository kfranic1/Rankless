import 'package:flutter/material.dart';
import 'package:rankless/shared/Interface.dart';
import 'package:rankless/shared/keepAliveThis.dart';
import 'CompanyHomeScreen.dart';
import 'EmployeeHomeScreen.dart';
import 'package:rankless/Review/ReviewScreen.dart';

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
    ReviewScreen(),
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
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedLabelStyle: TextStyle(
          fontFamily: font,
          color: Colors.white,
        ),
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
            label: 'Review',
            icon: Icon(Icons.score),
          ),
        ],
        onTap: (index) => setState(() {
          _currentIndex = index;
          _controller.animateToPage(index, duration: Duration(milliseconds: 250), curve: Curves.ease);
        }),
      ),
      body: PageView.builder(
        itemCount: 3,
        onPageChanged: (index) => setState(() => _currentIndex = index),
        controller: _controller,
        itemBuilder: (context, index) => _screens[index],
      ),
    );
  }
}
