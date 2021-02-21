import 'package:flutter/material.dart';
import 'package:rankless/auth.dart';

import 'Employee.dart';

class CustomAppBar {
  final AuthService _auth = AuthService();
  AppBar build(String title, Employee employee) {
    return AppBar(
      leading: Icon(Icons.circle),
      title: Text(title),
      actions: [
        employee == null
            ? Container()
            : employee.anonymus
                ? FlatButton.icon(
                    onPressed: () async {
                      await _auth.signOut();
                    },
                    icon: Icon(Icons.person),
                    label: Text("Create a profile"),
                  )
                : FlatButton.icon(
                    onPressed: () async {
                      await _auth.signOut();
                    },
                    icon: Icon(Icons.logout),
                    label: Text("logut"),
                  ),
      ],
    );
  }
}
