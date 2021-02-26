import 'package:rankless/Employee.dart';

enum TYPE { Text, RadioButton, Checkbox }

class Question {
  String questionText;
  TYPE answerType;
  String answerTextT;
  List<String> answerTextR;
  List<String> answerTextC;

  Question(this.questionText, this.answerType,
      {this.answerTextT, this.answerTextR, this.answerTextC});
}
