import 'package:rankless/Employee.dart';

enum TYPE { Text, RadioButton, Checkbox }

class Question {
  String questionText;
  TYPE answerType;
  String answerText;

  Question();
}
