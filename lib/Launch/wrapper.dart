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
            body: employee.dummy
                ? loader
                : StreamProvider<Employee>.value(
                    initialData: Employee(dummy: true),
                    updateShouldNotify: (a, b) => true,
                    value: employee.self,
                    builder: (context, child) {
                      employee.getImage();
                      final Employee temp = Provider.of<Employee>(context);
                      print(temp.companyUid);
                      print(employee.uid);
                      //if (temp.companyUid == null && !company.dummy)
                      //company = new Company(dummy: true);
                      //else if (company.uid != temp.companyUid) company = new Company(uid: temp.uid);
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
                            company.getImage();
                            return EmployeeHome();
                          });
                    }),
          );
  }
}
