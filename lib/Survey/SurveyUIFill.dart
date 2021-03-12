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

bool allAnswered = true;

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
                  return (ListTile(
                    leading: Text(
                      (index + 1).toString(),
                      style: TextStyle(
                          color: Colors.white,
                          fontFamily: 'Mulish',
                          fontSize: 18),
                    ),
                    title: Container(
                      child: Transform.translate(
                          offset: Offset(-15, -22), child: widget.qNa[index]),
                    ),
                    minVerticalPadding: 0,
                    minLeadingWidth: 0,
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 16, vertical: -10),
                  ));
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
              TextButton(
                onPressed: () {
                  //ovo je samo demonstraciju funkcionalnosti
                  setState(() {
                    widget.qNa = checkAnswered(widget.qNa);
                  });
                  if (!allAnswered) {
                    showDialog(
                        context: context,
                        builder: (context) {
                          return (AlertDialog(
                              title: Text(
                                "You haven't answered on all questions",
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.red[600]),
                              ),
                              backgroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                                side: BorderSide(color: Colors.white),
                              )));
                        });
                  }
                  //Navigator.pop(context);
                },
                child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Colors.transparent, borderRadius: borderRadius),
                    height: 60,
                    width: 200,
                    child: Text(
                      'Submit',
                      style: TextStyle(
                          //fontWeight: FontWeight.bold,
                          color: Colors.white,
                          fontFamily: 'Mulish',
                          fontSize: 22),
                    )),
              )
            ],
          ),
        ),
      ),
    );
  }
}

List<QuestionUIAnswer> checkAnswered(List<QuestionUIAnswer> list) {
  List<QuestionUIAnswer> result = [];
  list.forEach((element) {
    if (element.question.singleAnswer.isEmpty && element.question.mask == 0) {
      print(true);
      element.notAnsweredD =
          BoxDecoration(border: Border.all(color: Colors.red));
      allAnswered = false;
    }
    result.add(element);
  });
  return result;
}
