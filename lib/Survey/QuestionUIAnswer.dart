import 'package:flutter/material.dart';
import 'package:rankless/shared/Interface.dart';

import 'Question.dart';

// ignore: must_be_immutable
class QuestionUIAnswer extends StatefulWidget {
  final Question question;
  BoxDecoration notAnsweredD =
      BoxDecoration(border: Border.all(color: Colors.transparent));
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
    print(widget.question.multipleAnswers);
    return Container(
      decoration: widget.notAnsweredD,
      //color: Colors.transparent,
      // padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(30),
      child: ListView(shrinkWrap: true, children: [
        Container(
          // decoration: BoxDecoration(
          //   color: Colors.blue[200],
          //   borderRadius: borderRadius,
          // ),
          padding: EdgeInsets.all(10.0),
          child: Text(
            widget.question.questionText,
            style: TextStyle(
                fontFamily: font,
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold),
          ),
        ),
        Visibility(
          child: TextFormField(
            initialValue: widget.question.singleAnswer,
            onChanged: (value) {
              setState(() {
                widget.question.singleAnswer = value;
              });
            },
            keyboardType: TextInputType.multiline,
            maxLines: null,
            decoration: InputDecoration(
              hintText: "Answer...",
              fillColor: Colors.blue[700],
              hintStyle: TextStyle(color: Colors.grey),
              border: InputBorder.none,
            ),
            style: TextStyle(color: Colors.grey), // white70?
          ),
          visible: widget.question.answerType == TYPE.Text,
        ),
        Visibility(
          child: ListView(
            shrinkWrap: true,
            children: widget.question.multipleAnswers
                .map((e) => RadioListTile(
                      title: Text(
                        e,
                        style: TextStyle(color: Colors.white, fontFamily: font),
                      ),
                      value: e,
                      groupValue: _chosen,
                      onChanged: (String value) {
                        setState(() {
                          _chosen = value;
                          widget.question.mask = (1 <<
                              widget.question.multipleAnswers.indexOf(value));
                        });
                      },
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
                title: Text(
                  widget.question.multipleAnswers[index],
                  style: TextStyle(color: Colors.white, fontFamily: 'Mulish'),
                ),
                value: mask & (1 << index) != 0,
                onChanged: (value) {
                  setState(() {
                    mask ^= 1 << index;
                    widget.question.mask = mask;
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
