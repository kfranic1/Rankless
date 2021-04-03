import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rankless/User/Company.dart';
import 'package:rankless/User/Employee.dart';
import 'package:rankless/User/EmployeeHome.dart';
import 'package:rankless/Launch/authenticate.dart';
import 'package:rankless/shared/Interface.dart';
import 'package:rankless/shared/custom_app_bar.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Employee employee = Provider.of<Employee>(context);
    //Return to register screen implicitly by creating new instance of Authenticate
    if (employee == null) return Authenticate();
    //Handle user/guest login
    return Scaffold(
      appBar: CustomAppBar(employee: employee),
      body: Container(
        decoration: backgroundDecoration,
        child: employee.anonymus
            ? Center(
                child: Text(
                  "You are anonymus",
                  style: titleNameStyle.copyWith(fontWeight: FontWeight.normal),
                ),
              )
            : FutureBuilder(
                future: employee.getEmployee(true),
                builder: (context, snapshot) => snapshot.connectionState == ConnectionState.done
                    ? StreamProvider<Employee>.value(
                        initialData: null,
                        updateShouldNotify: (a, b) => true,
                        value: employee.self,
                        child: EmployeeHome(),
                      )
                    : loader,
              ),
      ),
    );
  }
}
