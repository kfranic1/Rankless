import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rankless/Survey/Results.dart';
import 'package:rankless/Survey/Survey.dart';
import 'package:rankless/Survey/SurveyUI.dart';
import 'package:rankless/User/Employee.dart';
import 'package:rankless/shared/Interface.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:search_choices/search_choices.dart';
import 'Company.dart';

class Manage extends StatefulWidget {
  final Company company;
  Manage(this.company);
  @override
  _ManageState createState() => _ManageState();
}

class _ManageState extends State<Manage> {
  List<DropdownMenuItem<String>> searchEmployees = [];
  String foundEmployee;
  Widget _future;

  @override
  void initState() {
    widget.company.employees.forEach((element) {
      print(element.uid);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _future = _future == null ? getData() : _future;
    return Scaffold(
      body: Center(child: _future),
    );
  }

  Widget getData() {
    return FutureBuilder(
      future: widget.company.getEmployees(true).whenComplete(() => setState(() => widget.company.employees.forEach((element) {
            String temp = element.name + " " + element.surname;
            print(temp);
            this.searchEmployees.add(DropdownMenuItem(child: Text(temp), value: element.name));
          }))),
      builder: (context, snapshot) => snapshot.connectionState != ConnectionState.done
          ? loader
          : Container(
              height: double.infinity,
              width: double.infinity,
              decoration: backgroundDecoration,
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.only(top: 40),
                    child: Text(
                      "Manage",
                      style: titleNameStyle,
                    ),
                  ),
                  SearchChoices.single(
                    items: searchEmployees,
                    value: foundEmployee,
                    hint: "Seacrh employees",
                    searchHint: "Search employees",
                    onChanged: (value) {
                      setState(() {
                        foundEmployee = value;
                      });
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
