import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rankless/createCompany.dart';
import 'package:rankless/custom_app_bar.dart';

import 'Company.dart';
import 'Employee.dart';

class CompanyHomeScreen extends StatefulWidget {
  final Company company;
  CompanyHomeScreen(this.company);
  @override
  _CompanyHomeScreenState createState() => _CompanyHomeScreenState();
}

class _CompanyHomeScreenState extends State<CompanyHomeScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.company.self,
      initialData: widget.company,
      builder: (context, snapshot) {
        return Center(
          child: Text(
            "Company is " + widget.company.name,
          ),
        );
      },
    );
  }
}
