import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rankless/shared/Interface.dart';

import 'Survey.dart';

class SurveyUIFill extends StatefulWidget {
  final Survey survey;
  SurveyUIFill(this.survey);
  @override
  _SurveyUIFillState createState() => _SurveyUIFillState();
}

class _SurveyUIFillState extends State<SurveyUIFill> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: backgroundDecoration,
        child: Column(
          children: [
            Text(
              widget.survey.name,
              style: TextStyle(color: Colors.white),
            )
          ],
        ),
      ),
    );
  }
}
