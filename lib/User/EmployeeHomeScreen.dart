import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
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
  void initState() {
    final employee = Provider.of<Employee>(context, listen: false);
    if (employee.request != null &&
        (employee.request.contains('accepted') ||
            employee.request.contains('denied')))
      SchedulerBinding.instance.addPostFrameCallback(
        (_) => showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text(
                    'You were ' +
                        ((employee.request.contains('accepted')
                                ? 'accepted to '
                                : 'denied from ') +
                            employee.request.substring(
                                employee.request.indexOf('%') + 1)),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await employee.updateEmployee(newRequest: '');
                      },
                      child: Text('OK'),
                    ),
                  ],
                ),
            useRootNavigator: false),
      );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final employee = Provider.of<Employee>(context);
    return ListView(
      children: [
        Text(
          "Hello " + employee.name,
        ),
        employee.companyUid == null
            ? employee.request != ''
                ? Column(children: [
                    Text("You sent request to " +
                        employee.request
                            .substring(employee.request.indexOf('%') + 1)),
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
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
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
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: TextButton(
                            child: Text("Join Company"),
                            onPressed: () => Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => JoinCompany(employee),
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
