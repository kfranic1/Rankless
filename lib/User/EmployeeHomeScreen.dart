import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'createCompany.dart';
import 'JoinCompany.dart';

import 'Employee.dart';

class EmployeeHomeScreen extends StatefulWidget {
  @override
  _EmployeeHomeScreenState createState() => _EmployeeHomeScreenState();
}

class _EmployeeHomeScreenState extends State<EmployeeHomeScreen> {
  bool isCancelDisabled = false;
  @override
  Widget build(BuildContext context) {
    final employee = Provider.of<Employee>(context);
    /*if (employee != null &&
        employee.request != null &&
        (employee.request.contains('accepted') ||
            employee.request.contains('denied')))
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'You were ' +
                (employee.request.contains('accepted')
                    ? 'accepted to '
                    : 'denied from ' +
                        employee.request
                            .substring(employee.request.indexOf('%') + 1)),
          ),
          action: SnackBarAction(
            onPressed: () async {
              await employee.updateEmployee(newRequest: '');
            },
            label: 'OK',
          ),
        ),
      );*/
    return employee == null
        ? Center(child: CircularProgressIndicator())
        : ListView(
            children: [
              Text(
                "Hello " + employee.name,
              ),
              employee.companyUid == null
                  ? employee.request != ''
                      ? Column(children: [
                          Text("You sent request to " +
                              employee.request.substring(
                                  employee.request.indexOf('%') + 1)),
                          isCancelDisabled
                              ? Container()
                              : TextButton(
                                  onPressed: () async {
                                    setState(() => isCancelDisabled = true);
                                    await employee.cancelRequestToCompany();
                                    setState(() => isCancelDisabled = false);
                                  },
                                  child: Text("Cancel request"),
                                ),
                        ])
                      : Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: TextButton(
                                    child: Text("Create Company"),
                                    onPressed: () => Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                CreateCompany(employee),
                                          ),
                                        )),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: TextButton(
                                  child: Text("Join Company"),
                                  onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            JoinCompany(employee),
                                      )),
                                ),
                              ),
                            ),
                          ],
                        )
                  : Text("You are already in company"),
              employee.roles.length != 0
                  ? Text(employee.roles[0])
                  : Text('Roles loading'),
            ],
          );
  }
}
