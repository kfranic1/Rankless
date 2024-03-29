import 'package:flutter/material.dart';
import 'package:rankless/shared/Interface.dart';

import 'Question.dart';

class QuestionUIAnswer extends StatefulWidget {
  final Question question;
  BoxDecoration notAnsweredD = BoxDecoration(border: Border.all(color: Colors.transparent));

  QuestionUIAnswer(this.question);

  @override
  _QuestionUIAnswerState createState() => _QuestionUIAnswerState();
}

class _QuestionUIAnswerState extends State<QuestionUIAnswer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: widget.notAnsweredD,
      margin: EdgeInsets.all(30),
      child: ListView(
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        children: [
          Container(
            padding: EdgeInsets.all(10.0),
            child: Text(
              widget.question.questionText,
              style: inputTextStyle.copyWith(fontWeight: FontWeight.bold),
            ),
          ),
          widget.question.answerType == TYPE.Text
              ? TextFormField(
                  initialValue: widget.question.singleAnswer,
                  onChanged: (value) => setState(() => widget.question.singleAnswer = value),
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
                          .map(
                            (e) => Theme(
                              data: ThemeData(unselectedWidgetColor: Colors.white),
                              child: RadioListTile(
                                title: Text(
                                  e,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: font,
                                  ),
                                ),
                                value: e,
                                groupValue: widget.question.mask == 0 ? null : widget.question.multipleAnswers[getFromMask(widget.question.mask)],
                                onChanged: (String value) =>
                                    setState(() => widget.question.mask = (1 << widget.question.multipleAnswers.indexOf(value))),
                                activeColor: Colors.white,
                                // selectedTileColor: Colors.white,
                              ),
                            ),
                          )
                          .toList(),
                    )
                  : ListView.builder(
                      physics: ClampingScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: widget.question.multipleAnswers.length,
                      itemBuilder: (context, index) => Theme(
                        data: ThemeData(unselectedWidgetColor: Colors.white),
                        child: CheckboxListTile(
                          title: Text(
                            widget.question.multipleAnswers[index],
                            style: TextStyle(
                              color: Colors.white,
                              fontFamily: 'Mulish',
                            ),
                          ),
                          value: widget.question.mask & (1 << index) != 0,
                          onChanged: (value) => setState(() => widget.question.mask ^= 1 << index),
                          controlAffinity: ListTileControlAffinity.leading,
                          checkColor: Colors.white,
                          activeColor: Colors.transparent,
                        ),
                      ),
                    ),
        ],
      ),
    );
  }
}
