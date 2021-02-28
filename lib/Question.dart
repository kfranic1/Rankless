import 'package:rankless/Employee.dart';

enum TYPE { Text, RadioButton, Checkbox }

class Question {
  String questionText;
  TYPE answerType;
  String singleAnswer;
  List<String> multipleAnswers = List.generate(3, (index) => 'q$index');

  Question(this.questionText, this.answerType,
      {this.singleAnswer, this.multipleAnswers}) {
    answerType = TYPE.Text;
    singleAnswer = '';
    multipleAnswers = List.generate(3, (index) => 'q$index');
  }
}
