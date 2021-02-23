import 'package:rankless/Employee.dart';

class Survey {
  String name;
  //List<Question> qNa;
  List<Employee> filled;
  List<Employee> notFilled;
  List<String> results; //to je lista odgovora preko kojih biljezimo rezultate

  Survey(this.name);
}
