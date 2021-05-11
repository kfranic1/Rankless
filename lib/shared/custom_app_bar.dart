import 'package:flutter/material.dart';
import 'package:fluttericon/entypo_icons.dart';
import 'package:rankless/Launch/auth.dart';

import 'package:rankless/User/Employee.dart';
import 'package:rankless/shared/Interface.dart';

class CustomAppBar extends AppBar {
  final String titleText;
  final Employee employee;
  final bool show;
  CustomAppBar({this.titleText = 'Rankless', this.employee, this.show = true})
      : super(
          leading: show
              ? Icon(
                  Entypo.chart_line,
                  size: 30,
                )
              : null,
          title: Text(
            titleText,
            style: TextStyle(fontFamily: font),
          ),
          actions: [
            employee == null
                ? Container()
                : IconButton(
                    onPressed: () async => await AuthService().signOut(),
                    icon: Icon(
                      Icons.logout,
                      color: Colors.white,
                    ),
                  )
          ],
          backgroundColor: Colors.black,
        );
}
