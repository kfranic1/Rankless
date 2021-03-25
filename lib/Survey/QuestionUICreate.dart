import 'package:customtogglebuttons/customtogglebuttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'Question.dart';
import 'package:rankless/shared/Interface.dart';

class QuestionUICreate extends StatefulWidget {
  Question _question = new Question();
  List<TextEditingController> _controllers = [];

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
  List<TextEditingController> _controllers = [];

  List<bool> _answerTypes = List.generate(3, (_) => false); //_ == 0 tak da prvi bude true na pocetku a ostali false
  Widget _proba = Text('');
  int _counter;
  Icon _icon;
  @override
  void initState() {
    _question.multipleAnswers = [];
    // if (_question.controllers != null) {
    //   _counter = _question.controllers.length;
    // } else
    //   _counter = 0;
    // if (_question.multipleAnswers != null) {
    //   _counter = _question.multipleAnswers.length;
    //   print('if2');
    // }
    // if (_question.answersListView != null) _proba = _question.answersListView;
    if (_question.answerType != null) {
      toggleButtonsFunc(_question.getIndexForType(_question.answerType));
      super.initState();
    }
  }

  @override
  Widget build(BuildContext context) {
    widget.getQuestion();

    if (_question.controllers != null) {
      _counter = _question.controllers.length;
    }

    // print(_question.answerType);
    // _controllers.forEach((element) {
    //   print(element.text);
    // });
    // _question.answersListView = _proba;
    _question.controllers = _controllers;
    if (_question.answerType == TYPE.RadioButton)
      _icon = Icon(Icons.radio_button_unchecked, color: shadedWhite);
    else
      _icon = Icon(Icons.check_box_outline_blank, color: shadedWhite);
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
          CustomToggleButtons(
            children: [
              // TODO labels
              Icon(
                Icons.textsms, /*color: Colors.white70*/
              ),
              Icon(Icons.radio_button_checked),
              Icon(Icons.check_box),
            ],
            // odredjivanje da toggle buttoni rade kak spada (kad se jedan upali da se drugi ugase)
            isSelected: _answerTypes,
            onPressed: (int index) {
              toggleButtonsFunc(index);
            },

            color: Colors.white,
            selectedColor: Colors.deepPurple[900],
            fillColor: containerBackgroundColor, // lighterBlue / opacityWhite
            unselectedFillColor: containerBackgroundColor,
            // borderWidth: 10,
            // borderColor: Colors.white10,
            renderBorder: true,
            spacing: 30.0,
          ),
          SizedBox(
            height: 10,
          ),
          Visibility(
            child: TextField(
              decoration: textFieldDecoration.copyWith(
                // focusedBorder: UnderlineInputBorder(
                //     borderSide: BorderSide(color: Colors.red)),
                hintText: "Answer",
                disabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                  color: Colors.blue[200],
                )),
                enabled: false,
              ),
              onChanged: (value) {
                setState(() => _question.singleAnswer = value); // ovo se nikad nece dogadjat
              },
            ),
            visible: _answerTypes[0],
          ),
          Visibility(
            child: _proba,
            visible: _answerTypes[1] || _answerTypes[2],
          ),

          // Prikaz radio button odgovora
          multipleChoiceAnswer(type: 1),

          // Prikaz checkbox odgovora
          multipleChoiceAnswer(type: 2),
        ],
      ),
    );
  }

// adding an answer for multiple answers types (RadioButton and Checkbox)
  Widget multipleChoiceAnswer({type: int}) {
    return Visibility(
      child: IconButton(
        icon: Icon(Icons.add_circle_outline, color: shadedWhite),
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

// creating an answer in multiple answers types
  void multipleChoiceAnswerWork(int count) {
    _proba = (ListView.builder(
      physics: ClampingScrollPhysics(),
      shrinkWrap: true,
      itemCount: count,
      itemBuilder: (context, index) {
        return ListTile(
          leading: _icon,
          title: TextFormField(
            controller: _controllers[index],
            style: inputTextStyle,
            decoration: InputDecoration(
              hintText: "Add text...",
              hintStyle: TextStyle(
                fontFamily: font,
                fontSize: 16,
                // color: Colors.blue[200],
                decorationColor: Colors.white,
              ),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                color: Colors.blue[200],
              )),
            ),
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

  void toggleButtonsFunc(int index) {
    setState(() {
      for (int i = 0; i < 3; i++) {
        _answerTypes[i] = false;
      }
      _answerTypes[index] = !_answerTypes[index];
      _question.answerType = _question.getAnswerType(index);
    });
  }
}
