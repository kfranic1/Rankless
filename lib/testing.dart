import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rankless/Employee.dart';
import 'package:rankless/EmployeeHome.dart';
import 'package:rankless/authenticate.dart';
import 'package:rankless/custom_app_bar.dart';

class Testing extends StatelessWidget {
  final Widget what;
  Testing(this.what);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: what, //Tu umjesto null stavite sta zelite testirat
      ),
    );
  }
}
