import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rankless/Employee.dart';
import 'package:rankless/EmployeeHome.dart';
import 'package:rankless/authenticate.dart';
import 'package:rankless/custom_app_bar.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Employee employee = Provider.of<Employee>(context);
    if (employee == null) return Authenticate();
    if (employee.name == 'anonymus')
      return Scaffold(
        appBar: CustomAppBar().build("Guest", true),
      );
    return EmployeeHome();
  }
}
