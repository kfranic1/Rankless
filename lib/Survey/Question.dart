import 'package:flutter/material.dart';

enum TYPE { Text, RadioButton, Checkbox }

class Question {
  String questionText;
  TYPE answerType;
  String singleAnswer = ''; //Teksutalni odgovor
  int mask = 0; //Odabrani odgovor(ili vise njih ako je moguce)
  List<String> multipleAnswers = [];
  List<TextEditingController> controllers = [];

  Question({this.questionText, this.answerType = TYPE.Text, this.singleAnswer, this.multipleAnswers});

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

  Map<String, dynamic> toMap() {
    return {
      'text': this.questionText,
      'type': this.answerType.toString(),
      'multiple': this.multipleAnswers,
    };
  }

  Question fromMap(Map<String, dynamic> map) {
    this.questionText = map['text'];
    this.answerType = map['type'] == 'TYPE.Text'
        ? TYPE.Text
        : map['type'] == 'TYPE.RadioButton'
            ? TYPE.RadioButton
            : TYPE.Checkbox;
    this.multipleAnswers = List<String>.from(map['multiple'] as List<dynamic>);
    return this;
  }
}
