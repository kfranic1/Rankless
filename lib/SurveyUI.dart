import 'dart:ui';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:intl/intl.dart';
import 'package:rankless/Company.dart';
import 'package:rankless/QuestionUICreate.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
import 'Question.dart';
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
  DateTime selectedFrom = DateTime.now();
  DateTime selectedTo = DateTime.now();
  DateFormat formatted = DateFormat('dd-MM-yyyy');
  List<int> selectedTags = [];
  QuestionUICreate createdQ;

  //samo za provjeru
  List<String> tags = [
    'teamOne',
    'teamTwo',
    'teamThree',
    'teamFour',
    'teamFive',
    'teamSix'
  ];

  @override
  Widget build(BuildContext context) {
    //provjera za tagove
    final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();
    List<String> who = tags;
    // ovo između služi samo za provjeru
    for (int i = 0; i < tags.length; i++) {
      selectedTags.add(i);
    }
    return Scaffold(
        body: Container(
      decoration: BoxDecoration(
          gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
            Colors.black,
            const Color(0xff3f51b5)
          ])), //ovdje su boje za gradient pozadine
      child: Column(
        children: <Widget>[
          Container(
            //survey name
            child: TextField(
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: this.survey.name,
                  hintStyle: TextStyle(
                    fontFamily: 'Mulish',
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                  )),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontFamily: 'Mulish',
                fontSize: 25,
                fontWeight: FontWeight.bold,
              ),
              onChanged: (value) {
                setState(() => this.survey.name = value);
                print(this.survey.name);
              },
            ),
            alignment: Alignment.topCenter,
            padding: EdgeInsets.all(20),
          ),
          Container(
            child: Row(
              children: <Widget>[
                //date
                Text('Date',
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontFamily: 'Mulish')),
                SizedBox(
                  width: 20,
                ),
                //from
                Expanded(
                  child: FlatButton(
                    child: Text(
                      formatted.format(selectedFrom),
                      style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Mulish',
                          color: Colors.white),
                    ),
                    onPressed: () => _selectFrom(context),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
                SizedBox(
                  child: Divider(
                    color: Colors.white,
                    indent: 8,
                    endIndent: 8,
                    thickness: 4,
                  ),
                  width: 35,
                ),
                //to
                Expanded(
                  child: FlatButton(
                    child: Text(
                      formatted.format(selectedTo),
                      style: TextStyle(
                          fontFamily: 'Mulish',
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                    onPressed: () => _selectTo(context),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.only(left: 15, right: 15),
          ),
          //for
          Container(
            child: Row(
              children: [
                Text(
                  'For',
                  style: TextStyle(
                      fontSize: 20, color: Colors.white, fontFamily: 'Mulish'),
                ),
                SizedBox(
                  width: 20,
                ),
                Expanded(
                  child: Tags(
                    key: _tagStateKey,
                    symmetry: false,
                    columns: 0,
                    horizontalScroll: false,
                    textField: TagsTextField(
                      helperTextStyle: TextStyle(color: Colors.white),
                      textStyle: TextStyle(
                        color: Colors.white,
                        fontFamily: 'Mulish',
                      ),
                      inputDecoration:
                          InputDecoration(alignLabelWithHint: true),
                      suggestions: tags,
                      suggestionTextColor: Colors.blue,
                      constraintSuggestion: true,
                      onSubmitted: (string) {
                        setState(() {
                          if (tags.contains(string)) who.add(string);
                        });
                      },
                    ),
                    itemCount: who.length,
                    itemBuilder: (index) {
                      final item = tags[index];
                      return ItemTags(
                        key: Key(index.toString()),
                        index: index,
                        title: item,
                        pressEnabled: true,
                        singleItem: false,
                        activeColor: Colors.blue,
                        color: Colors.grey,
                        //combine: ItemTagsCombine.withTextBefore,
                      );
                    },
                  ),
                ),
              ],
            ),
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.only(left: 15, right: 15, top: 12),
          ),
          //add question
          FlatButton.icon(
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return Dialog(
                        insetPadding: EdgeInsets.only(left: 0.0, right: 0.0),
                        backgroundColor: Colors.transparent,
                        child: ListView(
                          children: [
                            IconButton(
                                icon: Icon(Icons.cancel), onPressed: null),
                            createdQ = QuestionUICreate(),
                            FlatButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                  //showQuestion(context, )
                                },
                                child: Text(
                                  'Add',
                                  style: TextStyle(color: Colors.white),
                                ))
                          ],
                        ));
                  });
            },
            icon: Container(
              child: Icon(
                Icons.add_circle_outline,
                color: Colors.white,
              ),
            ),
            label: Text(
              "Add question",
              style: TextStyle(
                  color: Colors.white, fontSize: 20, fontFamily: 'Mulish'),
            ),
            padding: EdgeInsets.only(top: 35),
          ),
        ],
      ),
    ));
  }

  _selectFrom(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedFrom,
      firstDate: DateTime(selectedFrom.year),
      lastDate: DateTime(selectedFrom.year + 10),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark(),
          child: child,
        );
      },
    );
    if (picked.isBefore(selectedFrom)) {
      return showAlertDialog(context);
    }
    if (picked != null && picked != selectedFrom)
      setState(() {
        selectedFrom = picked;
        this.survey.from = selectedFrom;
      });
  }

  _selectTo(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedTo,
      firstDate: DateTime(selectedTo.year),
      lastDate: DateTime(selectedTo.year + 10),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark(),
          child: child,
        );
      },
    );
    if (picked.isBefore(selectedFrom)) {
      return showAlertDialog(context);
    }
    if (picked != null && picked != this.survey.from)
      setState(() {
        selectedTo = picked;
        this.survey.to = selectedTo;
      });
  }

  showAlertDialog(BuildContext context) {
    AlertDialog alert = AlertDialog(
        title: Text(
          "You've entered a wrong date",
          textAlign: TextAlign.center,
          style: TextStyle(color: Colors.red[600]),
        ),
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: Colors.white),
        ));
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  showQuestion(BuildContext context, Question question) {}
}
