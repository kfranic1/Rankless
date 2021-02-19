import 'package:flutter/material.dart';
import 'package:rankless/custom_app_bar.dart';

class EmployeeHome extends StatefulWidget {
  @override
  _EmployeeHomeState createState() => _EmployeeHomeState();
}

class _EmployeeHomeState extends State<EmployeeHome> {
  @override
  final CustomAppBar _appBar = CustomAppBar();
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar.build('Rankless', null),
      body: Center(
        child: Text('You are registered'),
      ),
    );
  }
}
