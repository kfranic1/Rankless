import 'package:flutter/material.dart';
import 'package:rankless/Launch/auth.dart';

import 'package:rankless/User/Employee.dart';

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
                ? TextButton.icon(
                    onPressed: () async {
                      await _auth.signOut();
                    },
                    icon: Icon(
                      Icons.login,
                      color: Colors.white,
                    ),
                    label: Text(
                      "register",
                      style: TextStyle(color: Colors.white),
                    ),
                  )
                : TextButton.icon(
                    onPressed: () async {
                      await _auth.signOut();
                    },
                    icon: Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                    label: Text(
                      "logut",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
      ],
    );
  }
}
