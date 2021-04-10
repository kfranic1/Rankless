import 'package:flutter/material.dart';
import 'package:rankless/Launch/auth.dart';

import 'package:rankless/User/Employee.dart';

class CustomAppBar extends AppBar {
  final String titleText;
  final Employee employee;
  final bool show;
  CustomAppBar({this.titleText = 'Rankless', this.employee, this.show = true})
      : super(
          leading: show ? Icon(Icons.circle) : null,
          title: Text(titleText),
          actions: [
            employee == null
                ? Container()
                : TextButton.icon(
                    onPressed: () async => await AuthService().signOut(),
                    icon: Icon(
                      employee.anonymus ? Icons.login : Icons.logout,
                      color: Colors.white,
                    ),
                    label: Text(
                      employee.anonymus ? "login" : 'logout',
                      style: TextStyle(color: Colors.white),
                    ),
                  )
          ],
          backgroundColor: Colors.black,
        );
}
