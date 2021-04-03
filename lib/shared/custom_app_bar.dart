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
                : employee.anonymus
                    ? TextButton.icon(
                        onPressed: () async => await AuthService().signOut(),
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
                        onPressed: () async => await AuthService().signOut(),
                        icon: Icon(
                          Icons.logout,
                          color: Colors.white,
                        ),
                        label: Text(
                          "logout",
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
          ],
          backgroundColor: Colors.black,
        );
}
