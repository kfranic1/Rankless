import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rankless/createCompany.dart';
import 'package:rankless/custom_app_bar.dart';

import 'Employee.dart';

class EmployeeHomeScreen extends StatefulWidget {
  final Employee employee;
  EmployeeHomeScreen(this.employee);
  @override
  _EmployeeHomeScreenState createState() => _EmployeeHomeScreenState();
}

class _EmployeeHomeScreenState extends State<EmployeeHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return widget.employee == null
        ? Center(
            child: Text("There is no user"),
          )
        : StreamBuilder(
            initialData: widget.employee,
            stream: widget.employee.self,
            builder: (context, snapshot) {
              if (!snapshot.hasData)
                return Center(
                  child: Text('You are not loged in'),
                );
              return ListView(
                children: [
                  Text(
                    "Hello " + widget.employee.name,
                  ),
                  FlatButton(
                      child: Text("Create Company"),
                      color: Colors.grey,
                      onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CreateCompany()))),
                ],
              );
            },
          );
  }
}
