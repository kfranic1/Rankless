import 'package:customtogglebuttons/customtogglebuttons.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rankless/Question.dart';
import 'package:rankless/shared/Interface.dart';

class QuestionUICreate extends StatefulWidget {
  Question _question = new Question();
  List<TextEditingController> _controllers = new List<TextEditingController>();

  @override
  _QuestionUICreateState createState() =>
      _QuestionUICreateState(_question, _controllers);

  Question getQuestion() {
    _controllers.forEach((element) {
      _question.multipleAnswers.add(element.text);
      print(element.text);
    });
    return _question;
  }
}

Decoration lighterContainerDecoration = BoxDecoration(
  borderRadius: borderRadius,
  color: Colors.white.withOpacity(0.4),
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
  List<TextEditingController> _controllers = new List<TextEditingController>();

  List<bool> _answerTypes = List.generate(3, (_) => false);
  Widget _proba = Text('');
  int _counter = 0;
  Icon _icon;

  @override
  Widget build(BuildContext context) {
    widget.getQuestion();
    if (_question.answerType == TYPE.RadioButton)
      _icon = Icon(Icons.radio_button_unchecked);
    else
      _icon = Icon(Icons.check_box_outline_blank, color: Colors.white70);
    multipleChoiceAnswerWork(
      _counter,
    );
    return Container(
      decoration: popOutDecoration,

      padding: const EdgeInsets.all(20.0),
      // margin: const EdgeInsets.all(20.0),
      // color: Colors.blue[300],
      child: Column(
        // shrinkWrap: true,
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
              decoration: textFieldDecoration.copyWith(
                  hintText: "Add text...", border: InputBorder.none),
              onChanged: (value) {
                setState(() => _question.questionText = value);
              },
            ),
          ),
          SizedBox(height: 15),
          Text(
            'Answer type',
            style: header,
          ),
          SizedBox(height: 10),
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
                _question.answerType = _question.getAnswerType(index);
              });
            },
            color: Colors.white,
            selectedColor: Colors.deepPurple[900],
            fillColor: Colors.blue[200],
            unselectedFillColor: Colors.blue[200],
            // borderWidth: 10,
            // borderColor: Colors.white10,
            renderBorder: true,
            spacing: 30.0,
          ),
          Visibility(
            child: TextField(
              decoration: textFieldDecoration.copyWith(
                // focusedBorder: UnderlineInputBorder(
                //     borderSide: BorderSide(color: Colors.red)),
                hintText: "Add text...",
                enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                  color: Colors.blue[200],
                )),

                // hintStyle: TextStyle(
                //   fontFamily: font,
                //   fontSize: 15,
                //   color: Colors.white60,
                // ),
              ),
              onChanged: (value) {
                setState(() => _question.singleAnswer = value);
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

  Widget multipleChoiceAnswer({type: int}) {
    return Visibility(
      child: IconButton(
        icon: Icon(Icons.add_circle_outline, color: Colors.white70),
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
    _proba = (ListView.builder(
      shrinkWrap: true,
      itemCount: count,
      itemBuilder: (context, index) {
        return ListTile(
          leading: _icon,
          title: TextFormField(
            controller: _controllers[index],
            decoration: InputDecoration(
              hintText: "Add text...",
              hintStyle: TextStyle(
                fontFamily: font,
                fontSize: 16,
                // color: Colors.blue[200]
              ),
              enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      // color: Colors.blue[200],
                      )),
            ),

            // expands: true,
            // minLines: null,
            // maxLines: null,
            // maxLength: 100,
          ),
          trailing: IconButton(
            icon: Icon(Icons.delete, color: Colors.white70),
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
