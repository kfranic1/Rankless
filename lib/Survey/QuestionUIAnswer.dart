import 'package:flutter/material.dart';
import 'package:rankless/shared/Interface.dart';

import 'Question.dart';

class QuestionUIAnswer extends StatefulWidget {
  final Question question;
  // QuestionUICreate(this.question);
  // List<bool> _selections = List.generate(3, (_) => false);
  // final Function toogleView;
  QuestionUIAnswer(this.question);
  @override
  _QuestionUIAnswerState createState() => _QuestionUIAnswerState();
}

class _QuestionUIAnswerState extends State<QuestionUIAnswer> {
  // TYPE answerType;
  // String singleAnswer;
  List<String> answerText = [];
  String _chosen;
  int mask = 0;
  @override
  Widget build(BuildContext context) {
    print(widget.question.answerType);
    return Container(
      color: Colors.transparent,
      // padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(30),
      child: ListView(children: [
        Container(
          decoration: popOutDecoration,
          // color: Colors.blue[100],
          // margin: EdgeInsets.all(10.0),
          padding: EdgeInsets.all(10.0),
          child: Text(
            widget.question.questionText,
            style: TextStyle(
              fontFamily: font,
              color: Colors.white,
              fontSize: 15,
            ),
          ),
        ),
        Visibility(
          child: TextFormField(
            decoration: InputDecoration(
                hintText: "Answer...",
                fillColor: Colors.blue[700],
                hintStyle: TextStyle(color: Colors.white60),
                border: InputBorder.none),
            initialValue: widget.question.singleAnswer,
            onChanged: (value) {
              setState(() {
                widget.question.singleAnswer = value;
              });
            },
            keyboardType: TextInputType.multiline,
          ),
          visible: widget.question.answerType == TYPE.Text,
        ),
        Visibility(
          child: ListView(
            // shrinkWrap: true,
            children: widget.question.multipleAnswers
                .map((e) => Expanded(
                      child: RadioListTile(
                        title: Text(e),
                        value: e,
                        groupValue: _chosen,
                        onChanged: (String value) {
                          setState(() {
                            _chosen = value;
                          });
                        },
                      ),
                    ))
                .toList(),
          ),
          visible: widget.question.answerType == TYPE.RadioButton,
        ),
        Visibility(
          child: ListView.builder(
            shrinkWrap: true,
            itemCount: widget.question.multipleAnswers.length,
            itemBuilder: (context, index) {
              return CheckboxListTile(
                title: Text(widget.question.multipleAnswers[index]),
                value: mask & (1 << index) != 0,
                onChanged: (value) {
                  setState(() {
                    mask ^= 1 << index;
                  });
                  print(mask);
                },
                controlAffinity: ListTileControlAffinity.leading,
              );
            },
          ),
          visible: widget.question.answerType == TYPE.Checkbox,
        ),
      ]),
    );
  }
}
