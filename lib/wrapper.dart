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
    //Return to log in screen -- implicitly by creating new instance of Authenticate
    if (employee == null) return Authenticate(employee);
    //Handle anonymus login
    if (employee.anonymus)
      return Scaffold(
        appBar: CustomAppBar().build("Guest", employee),
        body: Center(
          child: Text("You are a guest!"),
        ),
      );
    //Handle user login
    return EmployeeHome(employee);
  }
}
