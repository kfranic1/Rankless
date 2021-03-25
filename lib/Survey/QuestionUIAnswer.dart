import 'dart:math';

import 'package:flutter/material.dart';
import 'package:rankless/shared/Interface.dart';

import 'Question.dart';

// ignore: must_be_immutable
class QuestionUIAnswer extends StatefulWidget {
  final Question question;
  BoxDecoration notAnsweredD = BoxDecoration(border: Border.all(color: Colors.transparent));
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
  // List<String> answerText = [];

  @override
  Widget build(BuildContext context) {
    print(widget.question.answerType);
    print(widget.question.multipleAnswers);
    print(widget.question.mask);
    return Container(
      decoration: widget.notAnsweredD,
      //color: Colors.transparent,
      // padding: EdgeInsets.all(10),
      margin: EdgeInsets.all(30),
      child: ListView(physics: ClampingScrollPhysics(), shrinkWrap: true, children: [
        Container(
          // decoration: BoxDecoration(
          //   color: Colors.blue[200],
          //   borderRadius: borderRadius,
          // ),
          padding: EdgeInsets.all(10.0),
          child: Text(
            widget.question.questionText,
            style: TextStyle(fontFamily: font, color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        widget.question.answerType == TYPE.Text
            ? TextFormField(
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
                style: inputTextStyle, // white70?
              )
            : widget.question.answerType == TYPE.RadioButton
                ? ListView(
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    children: widget.question.multipleAnswers
                        .map((e) => Theme(
                              data: ThemeData(unselectedWidgetColor: Colors.white),
                              child: RadioListTile(
                                title: Text(
                                  e,
                                  style: TextStyle(color: Colors.white, fontFamily: font),
                                ),
                                value: e,
                                groupValue:
                                    widget.question.mask == 0 ? null : widget.question.multipleAnswers[(log(widget.question.mask) / log(2)).round()],
                                onChanged: (String value) {
                                  setState(() {
                                    widget.question.mask = (1 << widget.question.multipleAnswers.indexOf(value));
                                    print(widget.question.mask);
                                  });
                                },
                                activeColor: Colors.white,
                                // selectedTileColor: Colors.white,
                              ),
                            ))
                        .toList(),
                  )
                : ListView.builder(
                    physics: ClampingScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: widget.question.multipleAnswers.length,
                    itemBuilder: (context, index) {
                      return Theme(
                        data: ThemeData(unselectedWidgetColor: Colors.white),
                        child: CheckboxListTile(
                          title: Text(
                            widget.question.multipleAnswers[index],
                            style: TextStyle(color: Colors.white, fontFamily: 'Mulish'),
                          ),
                          value: widget.question.mask & (1 << index) != 0,
                          onChanged: (value) {
                            setState(() {
                              widget.question.mask ^= 1 << index;
                            });
                            print(widget.question.mask);
                          },
                          controlAffinity: ListTileControlAffinity.leading,
                          checkColor: Colors.white,
                          activeColor: Colors.transparent,
                        ),
                      );
                    },
                  ),
      ]),
    );
  }
}
