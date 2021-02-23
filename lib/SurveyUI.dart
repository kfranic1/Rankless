import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'Survey.dart';

class SurveyUI extends StatefulWidget {
  final Survey survey;
  SurveyUI(this.survey);
  @override
  _SurveyUIState createState() => _SurveyUIState(this.survey);
}

class _SurveyUIState extends State<SurveyUI> {
  Survey survey;
  _SurveyUIState(this.survey);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      children: <Widget>[
        Container(
          child: TextField(
            decoration: InputDecoration(
                border: InputBorder.none,
                hintText: this.survey.name,
                hintStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                )),
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
            ),
            onChanged: (value) {
              setState(() => this.survey.name = value);
            },
          ),
          alignment: Alignment.topCenter,
          padding: EdgeInsets.all(45.0),
        ),
        Container(
          child: Row(children: <Widget>[
            Text('Date', style: TextStyle(fontSize: 20, color: Colors.black)),
            //Date
          ]),
          alignment: Alignment.bottomLeft,
          margin: EdgeInsets.only(left: 25),
        )
      ],
    ));
  }
}
