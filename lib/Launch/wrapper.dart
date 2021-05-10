import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rankless/Launch/register.dart';
import 'package:rankless/User/Company.dart';
import 'package:rankless/User/Employee.dart';
import 'package:rankless/User/EmployeeHome.dart';
import 'package:rankless/shared/Interface.dart';
import 'package:rankless/shared/custom_app_bar.dart';

class Wrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final Employee employee = Provider.of<Employee>(context);
    Company company = Company(dummy: true);
    //Return to register screen implicitly by creating new instance of Authenticate
    return employee == null
        ? Register()
        : Scaffold(
            appBar: CustomAppBar(employee: employee),
            body: Container(
              decoration: backgroundDecoration,
              child: employee.dummy
                  ? loader
                  : StreamProvider<Employee>.value(
                      initialData: Employee(dummy: true),
                      updateShouldNotify: (a, b) => true,
                      value: employee.self,
                      builder: (context, child) {
                        final Employee temp = Provider.of<Employee>(context);
                        if (temp.companyUid == null) {
                          company = Company(dummy: true);
                          print("dummy");
                        } else if (company.uid != temp.companyUid) {
                          company = Company(uid: temp.companyUid);
                          print("New company " + temp.uid.toString());
                        }
                        return StreamProvider<Company>.value(
                            initialData: company,
                            updateShouldNotify: (a, b) => true,
                            value: company.self,
                            builder: (context, child) {
                              return EmployeeHome();
                            });
                      }),
            ),
          );
  }
}
