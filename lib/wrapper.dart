import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rankless/Company.dart';
import 'package:rankless/Employee.dart';
import 'package:rankless/EmployeeHome.dart';
import 'package:rankless/authenticate.dart';
import 'package:rankless/custom_app_bar.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Employee employee = Provider.of<Employee>(context);
    //Return to register screen implicitly by creating new instance of Authenticate
    if (employee == null) return Authenticate();
    //Handle user/guest login
    return Scaffold(
      appBar: CustomAppBar().build('Rankless', employee),
      body: employee.anonymus
          ? Center(
              child: Text("You are anonymus"),
            )
          : FutureBuilder(
              future: employee.getEmployee(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  Company company = Company(uid: employee.companyUid);
                  return FutureBuilder(
                    future: company.getData(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return EmployeeHome(employee, company);
                      }
                      return Center(child: CircularProgressIndicator());
                    },
                  );
                }
                return Center(child: CircularProgressIndicator());
              },
            ),
    );
  }
}
