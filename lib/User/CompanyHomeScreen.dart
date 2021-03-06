import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rankless/User/Employee.dart';

import 'Company.dart';

class CompanyHomeScreen extends StatefulWidget {
  @override
  _CompanyHomeScreenState createState() => _CompanyHomeScreenState();
}

class _CompanyHomeScreenState extends State<CompanyHomeScreen> {
  ListView requests;
  bool handling = false;
  @override
  Widget build(BuildContext context) {
    final Company company = Provider.of<Company>(context);
    final Employee me = Provider.of<Employee>(context);
    return company == null
        ? Center(
            child: Text('You are '),
          )
        : ListView(
            children: [
              Center(
                child: Text(
                  "Company is " + company.name,
                ),
              ),
              if (me.roles.contains('admin') && company.requests.length != 0)
                Align(
                  alignment: Alignment.topCenter,
                  child: handling
                      ? CircularProgressIndicator()
                      : Card(
                          child: Column(
                            children: [
                              company.getRequestAsText(),
                              Row(
                                children: [
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        color: Colors.green,
                                        child: TextButton(
                                            child: Text('Allow'),
                                            onPressed: () async {
                                              setState(() => handling = true);
                                              company.handleRequest(true);
                                              setState(() => handling = false);
                                            }),
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                        color: Colors.red,
                                        child: TextButton(
                                            child: Text('Deny'),
                                            onPressed: () async {
                                              setState(() {});
                                              company.handleRequest(false);
                                              setState(() => handling = false);
                                            }),
                                      ),
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                )
            ],
          );
  }
}
