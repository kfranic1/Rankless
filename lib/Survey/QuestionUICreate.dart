import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Question.dart';
import 'package:rankless/shared/Interface.dart';

class QuestionUICreate extends StatefulWidget {
  final Question _question = new Question();
  final List<TextEditingController> _controllers = [];

  @override
  _QuestionUICreateState createState() => _QuestionUICreateState(_question, _controllers);

  Question getQuestion() {
    _question.multipleAnswers = _controllers.map((e) => e.text).toList();
    return _question;
  }
}

// constants, decorations, style...

const shadedWhite = Colors.white70; // used for icons in multiple answers types
Color lighterBlue = Colors.blue[200]; // used as background for containers
Color opacityWhite = Colors.white.withOpacity(0.4); // optional: used as background for containers
Color containerBackgroundColor = opacityWhite;
// uredit cu jos ove boje

Decoration lighterContainerDecoration = BoxDecoration(
  borderRadius: borderRadius,
  color: containerBackgroundColor,
);

InputDecoration textFieldDecoration = InputDecoration(
  // border: InputBorder.none,
  hintStyle: TextStyle(fontFamily: font, color: Colors.white60, fontSize: 15),
);

TextStyle header = TextStyle(
  fontFamily: font,
  color: Colors.white,
  fontSize: 20,
);

class _QuestionUICreateState extends State<QuestionUICreate> {
  _QuestionUICreateState(this._question, this._controllers);

  Question _question;
  List<TextEditingController> _controllers;

  List<bool> _answerTypes;
  Widget _proba = Text('');
  int _counter;
  @override
  void initState() {
    _answerTypes = List.generate(
        3, (_) => _ == widget._question.getIndexForType(widget._question.answerType)); //_ == 0 tak da prvi bude true na pocetku a ostali false
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    _counter = _question.controllers.length;
    _question.controllers = _controllers;
    multipleChoiceAnswerWork(_counter);

    return Container(
      decoration: popOutDecoration,
      padding: const EdgeInsets.all(20.0),
      child: Column(
        children: [
          Text(
            'Question',
            style: header,
            textAlign: TextAlign.right,
          ),
          SizedBox(height: 10),
          Container(
            decoration: lighterContainerDecoration,
            padding: EdgeInsets.all(8.0),
            child: TextFormField(
              initialValue: _question.questionText,
              decoration: textFieldDecoration.copyWith(hintText: "Add text...", border: InputBorder.none),
              style: TextStyle(fontFamily: font),
              onChanged: (value) {
                setState(() => _question.questionText = value);
              },
            ),
          ),
          SizedBox(height: 20),
          Text(
            'Answer type',
            style: header,
          ),
          SizedBox(height: 15),
          Container(
            child: LayoutBuilder(
              builder: (context, constraints) => ToggleButtons(
                constraints: BoxConstraints.expand(width: constraints.maxWidth / 3, height: 60),
                children: [
                  // TODO labels
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.textsms),
                      Text('Text', style: inputTextStyle),
                    ],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [Icon(Icons.radio_button_checked), Text('Radio', style: inputTextStyle)],
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_box),
                      Text('Checkbox', style: inputTextStyle),
                    ],
                  ),
                ],
                isSelected: _answerTypes,
                onPressed: (int index) => setState(() {
                  for (int i = 0; i < 3; i++) _answerTypes[i] = i == index;
                  _question.answerType = _question.getAnswerType(index);
                }),
                color: Colors.white,
                selectedColor: Colors.deepPurple[900],
                //fillColor: containerBackgroundColor, // lighterBlue / opacityWhite
                //unselectedFillColor: containerBackgroundColor,
                fillColor: Colors.white.withOpacity(0.4),
                borderRadius: borderRadius,
                renderBorder: false,
                //spacing: 30.0,
              ),
            ),
          ),
          SizedBox(height: 10),
          Visibility(
            child: TextField(
              decoration: textFieldDecoration.copyWith(
                hintText: "Answer",
                disabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue[200])),
                enabled: false,
              ),
            ),
            visible: _answerTypes[0],
          ),
          Visibility(
            child: _proba,
            visible: _answerTypes[1] || _answerTypes[2],
          ),

          // Prikaz radio button odgovora
          multipleChoiceAnswer(1),

          // Prikaz checkbox odgovora
          multipleChoiceAnswer(2),
        ],
      ),
    );
  }

// adding an answer for multiple answers types (RadioButton and Checkbox)
  Widget multipleChoiceAnswer(int type) {
    return Visibility(
      child: IconButton(
        icon: Icon(
          Icons.add_circle_outline,
          color: shadedWhite,
        ),
        onPressed: () {
          setState(() {
            _controllers.add(new TextEditingController());
            _counter++;
            multipleChoiceAnswerWork(_counter);
          });
        },
      ),
      visible: _answerTypes[type],
    );
  }

// creating an answer in multiple answers types
  void multipleChoiceAnswerWork(int count) {
    _proba = (ListView.builder(
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: count,
      itemBuilder: (context, index) {
        return ListTile(
          leading: Icon(
            _question.answerType == TYPE.RadioButton ? Icons.radio_button_unchecked : Icons.check_box_outline_blank,
            color: shadedWhite,
          ),
          title: TextFormField(
            controller: _controllers[index],
            style: inputTextStyle,
            cursorColor: Colors.white,
            decoration: InputDecoration(
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.white),
                ),
                border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                hintText: "Add text...",
                hintStyle: TextStyle(
                  fontFamily: font,
                  fontSize: 16,
                  // color: Colors.blue[200],
                  decorationColor: Colors.white,
                ),
                enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue[200]))),
            keyboardType: TextInputType.multiline,
            maxLines: null,
          ),
          trailing: IconButton(
            icon: Icon(Icons.delete, color: shadedWhite),
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
