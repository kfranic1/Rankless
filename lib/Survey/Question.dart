import 'package:flutter/material.dart';

enum TYPE { Text, RadioButton, Checkbox }

class Question {
  String questionText;
  TYPE answerType;
  String singleAnswer;
  List<String> multipleAnswers = []; //= List.generate(3, (index) => 'q$index');
  // Widget answersListView;
  List<TextEditingController> controllers = [];

  Question(
      {this.questionText,
      this.answerType,
      this.singleAnswer,
      this.multipleAnswers}) {
    // answerType = TYPE.RadioButton;
    singleAnswer = '';
    // multipleAnswers = List.generate(3, (index) => 'q$index');
  }

  TYPE getAnswerType(int i) {
    if (i == 0) return TYPE.Text;
    if (i == 1) return TYPE.RadioButton;
    return TYPE.Checkbox;
  }

  int getIndexForType(TYPE t) {
    if (t == TYPE.Text) return 0;
    if (t == TYPE.RadioButton) return 1;
    return 2;
  }
}
