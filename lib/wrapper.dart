import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rankless/Employee.dart';
import 'package:rankless/EmployeeHome.dart';
import 'package:rankless/authenticate.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Employee employee = Provider.of<Employee>(context);
    //Return to register screen -- implicitly by creating new instance of Authenticate
    if (employee == null) return Authenticate();
    //Handle user/guest login
    return EmployeeHome(employee);
  }
}
