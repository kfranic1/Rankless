import 'package:flutter/material.dart';
import 'package:rankless/custom_app_bar.dart';

import 'Employee.dart';

class EmployeeHome extends StatefulWidget {
  final Employee employee;
  EmployeeHome(this.employee);
  @override
  _EmployeeHomeState createState() => _EmployeeHomeState();
}

class _EmployeeHomeState extends State<EmployeeHome> {
  final CustomAppBar _appBar = CustomAppBar();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar.build('Rankless', widget.employee),
      body: Center(
        child: Text('You are registered'),
      ),
    );
  }
}
