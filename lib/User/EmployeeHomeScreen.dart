import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:rankless/Survey/SurveyUIFill.dart';
import 'package:rankless/shared/Interface.dart';
import 'CreateCompany.dart';
import 'package:rankless/Survey/Survey.dart';
import 'JoinCompany.dart';

import 'Employee.dart';

class EmployeeHomeScreen extends StatefulWidget {
  @override
  _EmployeeHomeScreenState createState() => _EmployeeHomeScreenState();
}

class _EmployeeHomeScreenState extends State<EmployeeHomeScreen> {
  bool isCancelDisabled = false;
  bool imageLoading = false;
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
                            employee.request
                                .substring(employee.request.indexOf('%') + 1)),
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
    employee.surveys.forEach((element) {
      print(element.uid);
    });
    return ListView(
      children: [
        IconButton(
          iconSize: 100,
          icon: imageLoading
              ? Center(child: loader)
              : CircleAvatar(
                  radius: 50, //should be half of icon size
                  backgroundImage: employee.image == null
                      ? null
                      : Image.file(employee.image).image,
                  child: employee.image == null
                      ? Text(
                          (employee.name[0] + employee.surname[0])
                              .toUpperCase(),
                          style: TextStyle(fontSize: 30),
                        )
                      : null,
                ),
          onPressed: () async {
            setState(() => imageLoading = true);
            await employee.getImage();
            setState(() => imageLoading = false);
          },
        ),
        Center(
          child: Text(
            "Hello " + employee.name,
          ),
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
        employee.tags.length != 0
            ? Text(employee.tags[0])
            : Text('You have no tags'),
        employee.surveys.length > 0
            ? FutureBuilder(
                future: employee.handleSurveys(),
                builder: (context, snapshot) => snapshot.connectionState ==
                        ConnectionState.active
                    ? Center(
                        child: loader,
                      )
                    : Center(
                        child: TextButton(
                          onPressed: () async {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SurveyUIFill(employee.surveys[0], employee),
                              ),
                            );
                          },
                          child: Text('You have ' +
                              employee.surveys
                                  .where((element) {
                                    print(element.name);
                                    return element.status == STATUS.Active;
                                  })
                                  .length
                                  .toString() +
                              ' active and ' +
                              employee.surveys
                                  .where((element) =>
                                      element.status == STATUS.Upcoming)
                                  .length
                                  .toString() +
                              ' upcoming surveys'),
                        ),
                      ),
              )
            : Center(
                child: Text('There are no new surveys'),
              )
      ],
    );
  }
}
