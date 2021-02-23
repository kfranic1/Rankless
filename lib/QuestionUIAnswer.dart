import 'package:flutter/material.dart';

class QuestionUIAnswer extends StatefulWidget {
  // final Question question;       NAPRAVITI KLIKOM NA FINISH
  // QuestionUICreate(this.question);
  // List<bool> _selections = List.generate(3, (_) => false);
  final Function toogleView;
  QuestionUIAnswer({this.toogleView});
  @override
  _QuestionUIAnswerState createState() => _QuestionUIAnswerState();
}

class _QuestionUIAnswerState extends State<QuestionUIAnswer> {
  @override
  Widget build(BuildContext context) {
    return RaisedButton(onPressed: widget.toogleView, child: Text('toggle'));
  }
//  Pitanja _radio = Pitanja.q2;
  //  RadioListTile<Pitanja>(
  //         title: const Text('q1'),
  //         value: Pitanja.q1,
  //         groupValue: _radio,
  //         onChanged: (Pitanja value) {
  //           setState(() {
  //             _radio = value;
  //           });
  //         },
  //       ),
  //       RadioListTile<Pitanja>(
  //         title: TextFormField(
  //           initialValue: questionText,
  //           decoration: InputDecoration(hintText: "Add text..."),
  //           onChanged: (value) {
  //             setState(() => answerText[0].isEmpty
  //                 ? answerText.add(value)
  //                 : answerText[0] = value);
  //           },
  //         ),
  //         value: Pitanja.q2,
  //         groupValue: _radio,
  //         onChanged: (Pitanja value) {
  //           setState(() {
  //             _radio = value;
  //             answerText.forEach((element) {
  //               print(element);
  //             });
  //           });
  //         },
  //         toggleable: true,
  //       ),
}
