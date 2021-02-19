import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rankless/auth.dart';

import 'Employee.dart';

class CustomAppBar {
  final AuthService _auth = AuthService();
  AppBar build(String title, bool guest) {
    return AppBar(
      leading: Icon(Icons.circle),
      title: Text(title),
      actions: [
        guest
            ? FlatButton.icon(
                onPressed: () async {
                  await _auth.signOut();
                },
                icon: Icon(Icons.login),
                label: Text("login"),
              )
            : Container(),
      ],
    );
  }
}
