import 'dart:ui';

import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
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

  //samo za provjeru
  List<DropdownMenuItem> tags = [];

  @override
  Widget build(BuildContext context) {
    //provjera za tagove
    tags.add(DropdownMenuItem(
      child: Text('teamOne'),
    ));
    tags.add(DropdownMenuItem(
      child: Text('teamTwo'),
    ));
    tags.add(DropdownMenuItem(
      child: Text('teamThree'),
    ));
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
              },
            ),
            alignment: Alignment.topCenter,
            padding: EdgeInsets.all(15),
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
            padding: EdgeInsets.only(left: 17, right: 17),
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
                  child: SearchableDropdown.multiple(
                    items:
                        tags, //lista roles u klasi Company bi trebali biti DropDownMenuItem tipa
                    style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Mulish',
                    ),
                    hint: Text(
                      'teams',
                      style: TextStyle(
                          color: Colors.grey[600],
                          fontFamily: 'Mulish',
                          fontSize: 15),
                    ),
                    isCaseSensitiveSearch: true,
                    onChanged: (items) {
                      setState(() {
                        widget.survey.tags = items;
                        selectedTags = items;
                      });
                    },
                    closeButton: Container(),
                    searchHint: 'Who should get the survey',
                    isExpanded: true,
                  ),
                )
              ],
            ),
            alignment: Alignment.bottomCenter,
            margin: EdgeInsets.only(left: 17, right: 17, top: 12),
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
                            QuestionUICreate(),
                            FlatButton(
                                onPressed: null,
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
