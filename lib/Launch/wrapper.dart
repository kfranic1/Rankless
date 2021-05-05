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
    //TODO izvuci StreamProvidere u posebne widgete da se ne zove new Widget svaki put
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
                        company = temp.companyUid == null
                            ? Company(dummy: true)
                            : company.uid != temp.companyUid
                                ? Company(uid: temp.companyUid)
                                : company;
                        return StreamProvider<Company>.value(
                            initialData: company,
                            updateShouldNotify: (a, b) => true,
                            value: company.self,
                            builder: (context, child) {
                              print('rebuilding');
                              return EmployeeHome();
                            });
                      }),
            ),
          );
  }
}
