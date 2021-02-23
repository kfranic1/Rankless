import 'package:customtogglebuttons/customtogglebuttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rankless/Question.dart';
import 'package:rankless/QuestionUIAnswer.dart';

class QuestionUICreate extends StatefulWidget {
  // final Question question;       NAPRAVITI KLIKOM NA FINISH
  // QuestionUICreate(this.question);

  @override
  _QuestionUICreateState createState() => _QuestionUICreateState();
}

enum Pitanja { q1, q2 }

class _QuestionUICreateState extends State<QuestionUICreate> {
  String questionText = "";
  TYPE answerType = TYPE.Text;
  List<String> answerText = new List<String>();
  List<bool> _selections = List.generate(3, (_) => false);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          'Question',
          style: TextStyle(),
          textAlign: TextAlign.left,
        ),
        TextFormField(
          initialValue: questionText,
          decoration: InputDecoration(hintText: "Add text..."),
          onChanged: (value) {
            setState(() => questionText = value);
          },
        ),
        Text('Answer type'),
        CustomToggleButtons(
          children: [
            // TextButton(onPressed: null, child: Text('Text')),
            // FlatButton(onPressed: null, child: null),
            Icon(Icons.textsms),
            Icon(Icons.radio_button_checked),
            Icon(Icons.check_box),
          ],
          isSelected: _selections,
          onPressed: (int index) {
            setState(() {
              for (int i = 0; i < 3; i++) {
                _selections[i] = false;
              }
              _selections[index] = !_selections[index];
              // if (index == 0) {
              //   print("text?");
              //   style:
              //   TextStyle(color: Colors.cyan);
            });
          },
          color: Colors.amber,
          selectedColor: Colors.red,
          // borderWidth: 10,
          // borderColor: Colors.white10,
          renderBorder: true,
          spacing: 30.0,
        ),
        Row(
          children: [
            Icon(Icons.radio_button_unchecked),
            Text('text'),
          ],
          mainAxisAlignment: MainAxisAlignment.start,
        ),
        IconButton(
          icon: Icon(Icons.add_circle_outline),
          onPressed: () {
            Row(
              children: [
                Icon(Icons.radio_button_unchecked),
                Text('text'),
              ],
            );
          },
        ),
        RaisedButton(onPressed: () {
          QuestionUIAnswer();
        }),
      ],
    );
  }
}
