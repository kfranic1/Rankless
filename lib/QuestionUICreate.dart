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
  int _answerType;
  String singleAnswer;
  List<String> _answerTextRC = new List<String>();
  List<bool> _answerTypes = List.generate(3, (_) => false);
  // List<ListView> proba = new List<ListView>();
  Widget proba = Text('');
  List<TextEditingController> _controllers = new List<TextEditingController>();
  int _counter = 0;
  Icon icon;

  @override
  Widget build(BuildContext context) {
    if (_answerType == 1)
      icon = Icon(Icons.radio_button_unchecked);
    else
      icon = Icon(Icons.check_box_outline_blank);
    multipleChoiceAnswerWork(
      _counter,
    );
    return ListView(children: [
      Container(
        padding: const EdgeInsets.all(20.0),
        margin: const EdgeInsets.all(20.0),
        color: Colors.blue[300],
        child: Column(
          // shrinkWrap: true,
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
                  _answerType = index;
                });
              },
              color: Colors.white,
              selectedColor: Colors.deepPurple[900],
              fillColor: Colors.blue[200],
              // borderWidth: 10,
              // borderColor: Colors.white10,
              renderBorder: true,
              spacing: 30.0,
            ),
            Visibility(
              child: TextField(
                decoration: InputDecoration(hintText: "Add text..."),
                onChanged: (value) {
                  setState(() => singleAnswer = value);
                },
              ),
              visible: _answerTypes[0],
            ),
            Visibility(
              child: proba,
              // Column(
              //   children: proba,
              // ),
              visible: _answerTypes[1] || _answerTypes[2],
            ),

            // Prikaz radio button odgovora
            multipleChoiceAnswer(type: 1),

            // Prikaz checkbox odgovora
            multipleChoiceAnswer(type: 2),

            TextButton(
                child: Text('Add'),
                onPressed: () {
                  _controllers.forEach((element) {
                    print(element.text);
                  });
                  TYPE type;
                  // print(_answerType);
                  if (_answerType == 0) {
                    type = TYPE.Text;
                    Question(questionText, type, singleAnswer: singleAnswer);
                  } else if (_answerType == 1) {
                    type = TYPE.RadioButton;
                    Question(questionText, type,
                        multipleAnswers: _answerTextRC);
                  } else if (_answerType == 2) {
                    type = TYPE.Checkbox;
                    Question(questionText, type,
                        multipleAnswers: _answerTextRC);
                  } else
                    print('pogreska - nije odabran tip');

                  //  DESTROY pop-out ?
                }),
          ],
        ),
      ),
    ]);
  }

  Widget multipleChoiceAnswer({type: int}) {
    print("ansType: $_answerType");
    print(type);
    return Visibility(
      child: IconButton(
        icon: Icon(Icons.add_circle_outline),
        onPressed: () {
          setState(() {
            _controllers.add(new TextEditingController());
            // _controllers[_controllers.length - 1].text = '';
          });
          setState(() {
            _counter++;
            multipleChoiceAnswerWork(_counter);
          });
        },
      ),
      visible: _answerTypes[type],
    );
  }

  void multipleChoiceAnswerWork(int count) {
    proba = (ListView.builder(
      shrinkWrap: true,
      itemCount: count,
      itemBuilder: (context, index) {
        // print("index: $index, count: $count, controllers.len: ${_controllers.length}");
        return ListTile(
          leading: icon,
          title: TextFormField(
            controller: _controllers[index],
            decoration: InputDecoration(hintText: "Add text..."),
          ),
          trailing: IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              setState(() {
                _counter--;
                _controllers.removeAt(index);
              });
            },
          ),
        );
      },
    ));
  }
}
