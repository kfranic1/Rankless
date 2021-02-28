import 'package:flutter/material.dart';
import 'package:rankless/Company.dart';
import 'package:rankless/Employee.dart';

import 'Question.dart';

class Survey {
  String name;
  Company company;
  List<Question> qNa;
  List<Employee> filled;
  List<Employee> notFilled;
  List<DropdownMenuItem> tags;
  List<String> results; //to je lista odgovora preko kojih biljezimo rezultate
  DateTime from;
  DateTime to;
  Survey(this.name);
}
