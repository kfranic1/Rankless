import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rankless/Survey/QuestionUIAnswer.dart';
import 'package:rankless/Survey/SurveyUI.dart';
import 'package:rankless/shared/Interface.dart';

import 'Survey.dart';

class SurveyUIFill extends StatefulWidget {
  final Survey survey;
  List<QuestionUIAnswer> qNa;

  SurveyUIFill(this.survey) {
    qNa = survey.qNa.map((e) => QuestionUIAnswer(e)).toList();
  }
  @override
  _SurveyUIFillState createState() => _SurveyUIFillState();
}

bool allAnswered;
BoxDecoration decorate =
    BoxDecoration(border: Border.all(color: Colors.transparent));

class _SurveyUIFillState extends State<SurveyUIFill> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: backgroundDecoration,
        child: Center(
          child: ListView(
            shrinkWrap: true,
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
              ListView.separated(
                physics: ClampingScrollPhysics(),
                key: UniqueKey(),
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
                  decoration: decorate,
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
              ),
              TextButton(
                onPressed: () {
                  //ovo je samo demonstraciju funkcionalnosti
                  allAnswered = true;
                  setState(() {
                    widget.qNa = checkAnswered(widget.qNa);
                  });

                  if (!allAnswered) {
                    var snackBar = showWarning();
                    ScaffoldMessenger.of(context).showSnackBar(snackBar);
                  } else {
                    showConformationDialog(context);
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

  bool isAnswered(QuestionUIAnswer element) {
    if ((element.question.mask == null || element.question.mask == 0) &&
        (element.question.singleAnswer.isEmpty ||
            !singleAnswerCheck(element.question.singleAnswer))) {
      allAnswered = false;
      return false;
    }
    return true;
  }

  List<QuestionUIAnswer> checkAnswered(List<QuestionUIAnswer> list) {
    List<QuestionUIAnswer> result = [];
    list.forEach((element) {
      print(element.question.questionText +
          ' ' +
          element.question.mask.toString());
      if ((element.question.mask == null || element.question.mask == 0) &&
          (element.question.singleAnswer.isEmpty ||
              !singleAnswerCheck(element.question.singleAnswer))) {
        setState(() {
          allAnswered = false;
          element.notAnsweredD =
              BoxDecoration(border: Border.all(color: Colors.red));
        });
      } else {
        setState(() {
          element.notAnsweredD =
              BoxDecoration(border: Border.all(color: Colors.transparent));
        });
      }
      result.add(element);
    });
    return result;
  }
}

bool singleAnswerCheck(String singleAns) {
  if (singleAns.contains(RegExp(r'[A-Z]')) ||
      singleAns.contains(RegExp(r'[a-z]')) ||
      singleAns.contains(RegExp(r'[0-9]'))) return true;
  return false;
}

SnackBar showWarning() {
  return (SnackBar(
    duration: Duration(seconds: 2),
    content: Text(
      'You must answer on all of the questions',
      style: TextStyle(fontFamily: font, fontSize: 20),
    ),
  ));
}

showConformationDialog(BuildContext context) {
  // set up the buttons
  Widget cancelButton = TextButton(
    child: Text(
      "No",
      style: TextStyle(fontFamily: font, fontWeight: FontWeight.bold),
    ),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  Widget continueButton = TextButton(
    child: Text(
      "Yes",
      style: TextStyle(fontFamily: font, fontWeight: FontWeight.bold),
    ),
    onPressed: () {
      //ovdje bi trebala ići neka radnja da se izlazi iz surveya i ulazi u izbornik anketa
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    content: Text(
      "Are you sure you want to submit survey?",
      style: TextStyle(fontFamily: font, fontSize: 20),
    ),
    actions: [
      continueButton,
      cancelButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}
