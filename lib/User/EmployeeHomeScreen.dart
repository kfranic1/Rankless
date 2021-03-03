import 'package:flutter/material.dart';
import 'createCompany.dart';
import 'JoinCompany.dart';

import 'Employee.dart';

class EmployeeHomeScreen extends StatefulWidget {
  final Employee employee;
  EmployeeHomeScreen(this.employee);
  @override
  _EmployeeHomeScreenState createState() => _EmployeeHomeScreenState();
}

class _EmployeeHomeScreenState extends State<EmployeeHomeScreen> {
  bool isCancelDisabled = false;
  @override
  Widget build(BuildContext context) {
    print(widget.employee.roles);
    return StreamBuilder(
      initialData: widget.employee,
      stream: widget.employee.self,
      builder: (context, snapshot) {
        return ListView(
          children: [
            Text(
              "Hello " + widget.employee.name,
            ),
            widget.employee.companyUid == null
                ? widget.employee.request != ''
                    ? Column(children: [
                        Text("You sent request to " +
                            widget.employee.request.substring(
                                widget.employee.request.indexOf('%') + 1)),
                        isCancelDisabled
                            ? Container()
                            : FlatButton(
                                onPressed: () async {
                                  setState(() => isCancelDisabled = true);
                                  await widget.employee
                                      .cancelRequestToCompany();
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
                              child: FlatButton(
                                  child: Text("Create Company"),
                                  color: Colors.grey,
                                  onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              CreateCompany(widget.employee),
                                        ),
                                      )),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8.0),
                              child: FlatButton(
                                child: Text("Join Company"),
                                color: Colors.grey,
                                onPressed: () => Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (context) =>
                                          JoinCompany(widget.employee),
                                    )),
                              ),
                            ),
                          ),
                        ],
                      )
                : Text("You are already in company"),
            widget.employee.roles != null
                ? Text(widget.employee.roles[0])
                : Text('Roles loading'),
          ],
        );
      },
    );
  }
}
