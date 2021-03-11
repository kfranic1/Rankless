import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rankless/Survey/QuestionUIAnswer.dart';
import 'package:rankless/shared/Interface.dart';

import 'Survey.dart';

class SurveyUIFill extends StatefulWidget {
  final Survey survey;
  List<QuestionUIAnswer> qNa = [];
  SurveyUIFill(this.survey);
  @override
  _SurveyUIFillState createState() => _SurveyUIFillState();
}

class _SurveyUIFillState extends State<SurveyUIFill> {
  @override
  void initState() {
    for (int i = 0; i < widget.survey.qNa.length; i++) {
      QuestionUIAnswer qWa = QuestionUIAnswer(widget.survey.qNa[i]);
      widget.qNa.add(qWa);
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: backgroundDecoration,
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                child: Text(widget.survey.name,
                    style: TextStyle(
                      fontFamily: 'Mulish',
                      color: Colors.white,
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    )),
                alignment: Alignment.topCenter,
                padding: EdgeInsets.all(20), //ovo bi moglop biti drugacije
              ),
              Expanded(
                  child: ListView.separated(
                shrinkWrap: true,
                itemCount: widget.qNa.length,
                itemBuilder: (context, index) {
                  return widget.qNa[index];
                },
                separatorBuilder: (context, index) {
                  return SizedBox(
                    child: Divider(
                      color: Colors.white,
                    ),
                    height: 15,
                  );
                },
              )),
            ],
          ),
        ),
      ),
    );
  }
}
