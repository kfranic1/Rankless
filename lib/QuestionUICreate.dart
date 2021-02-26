import 'dart:developer';

import 'package:customtogglebuttons/customtogglebuttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rankless/Question.dart';

class QuestionUICreate extends StatefulWidget {
  // final Question question;       NAPRAVITI KLIKOM NA FINISH
  // QuestionUICreate(this.question);

  @override
  _QuestionUICreateState createState() => _QuestionUICreateState();
}

class _QuestionUICreateState extends State<QuestionUICreate> {
  String questionText = "";
  int answerType;
  String answerTextT;
  List<String> _answerTextRC = new List<String>();
  List<bool> _answerTypes = List.generate(3, (_) => false);
  List<Widget> proba = new List<Widget>();
  List<TextEditingController> _controllers = new List<TextEditingController>();
  int i = 0;
  // proba.add(Text('tekst1'));

  @override
  Widget build(BuildContext context) {
    return ListView(children: [
      Container(
        padding: const EdgeInsets.all(20.0),
        margin: const EdgeInsets.all(20.0),
        color: Colors.blue[200],
        child: Column(
          children: [
            Text(
              'Question',
              style: TextStyle(),
              textAlign: TextAlign.left,
            ),
            TextFormField(
              initialValue: '',
              decoration: InputDecoration(hintText: "Add text..."),
              onChanged: (value) {
                setState(() => questionText = value);
              },
            ),
            Text('$questionText'),
            Text('Answer type'),
            CustomToggleButtons(
              children: [
                // TextButton(onPressed: null, child: Text('Text')),
                // FlatButton(onPressed: null, child: null),
                Icon(Icons.textsms),
                Icon(Icons.radio_button_checked),
                Icon(Icons.check_box),
              ],
              isSelected: _answerTypes,
              onPressed: (int index) {
                setState(() {
                  for (int i = 0; i < 3; i++) {
                    _answerTypes[i] = false;
                  }
                  _answerTypes[index] = !_answerTypes[index];
                  answerType = index;
                });
              },
              color: Colors.amber,
              selectedColor: Colors.red,
              // borderWidth: 10,
              // borderColor: Colors.white10,
              renderBorder: true,
              spacing: 30.0,
            ),
            Visibility(
              child: TextField(
                decoration: InputDecoration(hintText: "Add text..."),
                onChanged: (value) {
                  setState(() => answerTextT = value);
                },
              ),
              visible: _answerTypes[0],
            ),
            Visibility(
              child: Column(
                children: proba,
              ),
              //     ListView.builder(
              //   itemCount: proba.length,
              //   itemBuilder: (context, index) {
              //     return proba[index];
              //   },
              // ),
              visible: _answerTypes[1],
            ),
            Visibility(
              child: IconButton(
                icon: Icon(Icons.add_circle_outline),
                onPressed: () {
                  i++;

                  setState(() {
                    _controllers.add(new TextEditingController());
                    // _controllers[_controllers.length - 1].text = '';
                  });
                  setState(() {
                    proba.add(Row(
                      key: ValueKey(i),
                      children: [
                        Icon(Icons.radio_button_unchecked),
                        Expanded(
                          child: TextFormField(
                            controller: _controllers[_controllers.length - 1],
                            decoration:
                                InputDecoration(hintText: "Add text..."),
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.delete),
                          onPressed: () {
                            setState(() {
                              print(_controllers[_controllers.length - 1].text);
                              _controllers.removeAt(_controllers.length - 1);
                              proba.removeAt(proba.length - 1);
                              // proba.indexOf();
                            });
                          },
                        )
                      ],
                    ));
                  });
                },
              ),
              visible: _answerTypes[1],
            ),
            TextButton(
                child: Text('Finish'),
                onPressed: () {
                  _controllers.forEach((element) {
                    print(element.text);
                  });
                  TYPE type;
                  if (answerType == 0) {
                    type = TYPE.Text;
                    Question(questionText, type, answerTextT: answerTextT);
                  } else if (answerType == 1) {
                    type = TYPE.RadioButton;
                    Question(questionText, type, answerTextR: _answerTextRC);
                  } else if (answerType == 2) {
                    type = TYPE.Checkbox;
                    Question(questionText, type, answerTextR: _answerTextRC);
                  } else
                    print('pogre[ka - nije odabran tip');

                  //  DESTROY pop-out ?
                }),
          ],
        ),
      ),
    ]);
  }
}
