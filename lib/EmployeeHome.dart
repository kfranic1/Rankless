import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rankless/custom_app_bar.dart';

import 'Employee.dart';

class EmployeeHome extends StatefulWidget {
  final Employee employee;
  EmployeeHome(this.employee);
  //Pazi employee moze biti guest to provjeravas sa employee.anonymus TODO
  @override
  _EmployeeHomeState createState() => _EmployeeHomeState();
}

class _EmployeeHomeState extends State<EmployeeHome> {
  final CustomAppBar _appBar = CustomAppBar();
  bool loading = true;
  String message = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar.build('Rankless', widget.employee),
      body: StreamBuilder(
        stream: widget.employee.self,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.active) {
            return ListView(children: [
              Center(child: Text("Hello " + widget.employee.name)),
              Center(
                child: Text(widget.employee.company != null
                    ? 'You are in ' + widget.employee.company.name
                    : "You are currently not in any company!"),
              )
            ]);
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }
}
