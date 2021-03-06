import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rankless/User/Company.dart';
import 'package:rankless/User/Employee.dart';
import 'package:rankless/User/EmployeeHome.dart';
import 'package:rankless/Launch/authenticate.dart';
import 'package:rankless/shared/custom_app_bar.dart';

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
              builder: (context, snapshot) =>
                  snapshot.connectionState == ConnectionState.done
                      ? StreamProvider<Employee>.value(
                          value: employee.self,
                          updateShouldNotify: (previous, current) => true,
                          child: EmployeeHome(),
                        )
                      : Center(
                          child: CircularProgressIndicator(),
                        ),
            ),
    );
  }
}
