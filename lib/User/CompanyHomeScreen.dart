import 'package:flutter/material.dart';

import 'Company.dart';

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
