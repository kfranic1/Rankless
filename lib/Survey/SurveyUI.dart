import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:intl/intl.dart';
import 'Question.dart';
import 'QuestionUICreate.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';
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
  Widget proba = Text('');
  int counter = -1;
  ListView questionLV = ListView(
    shrinkWrap: true,
  );
  List<ListTile> questionButtons = [];
  List<QuestionUICreate> questions = [];
  List<ListTile> suggestedQ = [];

  //samo za provjeru
  List<DropdownMenuItem> tags = [
    DropdownMenuItem(
      child: Text('one'),
      value: 'one',
    ),
    DropdownMenuItem(
      child: Text('two'),
      value: 'two',
    )
  ];
  List<String> showTags = [];

  @override
  Widget build(BuildContext context) {
    //provjera za tagove
    final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    // ovo između služi samo za provjeru

    return Scaffold(
      key: _scaffoldKey,
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
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextButton(
                        child: Text(
                          formatted.format(selectedFrom),
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Mulish',
                              color: Colors.white),
                        ),
                        onPressed: () => _selectFrom(context),
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
                    child: Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.white),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: TextButton(
                        child: Text(
                          formatted.format(selectedTo),
                          style: TextStyle(
                              fontFamily: 'Mulish',
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                        onPressed: () => _selectTo(context),
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
                        fontSize: 20,
                        color: Colors.white,
                        fontFamily: 'Mulish'),
                  ),
                  SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: SearchableDropdown.multiple(
                      items:
                          tags, //lista roles u klasi Company bi trebali biti DropDownMenuItem tipa
                      selectedItems: selectedTags,
                      selectedValueWidgetFn: (item) {
                        return Container();
                      },
                      icon: Icon(Icons.add_circle_outline),
                      underline: Container(),
                      onChanged: (value) {
                        setState(() {
                          selectedTags = value;
                          this.showTags = showTagsUpdate(selectedTags);
                        });
                      },
                      menuBackgroundColor: Colors.lightBlue[50],
                      displayItem: (item, selected) {
                        return Column(children: [
                          SizedBox(
                            height: 20,
                          ),
                          (Row(children: [
                            selected
                                ? Icon(
                                    Icons.check,
                                    color: Colors.green,
                                  )
                                : Icon(
                                    Icons.check_box_outline_blank,
                                    color: Colors.grey,
                                  ),
                            SizedBox(width: 7),
                            Expanded(
                              child: Text(
                                item.value,
                                style: TextStyle(
                                    fontFamily: 'Mulish', fontSize: 17),
                              ),
                            ),
                          ])),
                        ]);
                      },
                      doneButton: Container(),
                      closeButton: (selectedItems) {
                        return (selectedItems.isNotEmpty
                            ? "Save ${selectedItems.length == 1 ? '"' + tags[selectedItems.first].value.toString() + '"' : '(' + selectedItems.length.toString() + ')'}"
                            : "Save without selection");
                      },

                      searchHint: Text(
                        'Who should get the survey',
                        style: TextStyle(
                            fontFamily: 'Mulish',
                            fontWeight: FontWeight.bold,
                            fontSize: 18),
                      ),
                      isExpanded: false,
                      displayClearIcon: false,
                    ),
                  ),
                  Expanded(
                    flex: 3,
                    child: Tags(
                      key: _tagStateKey,
                      symmetry: false,
                      columns: 0,
                      horizontalScroll: true,
                      itemCount: showTags.length,
                      itemBuilder: (index) {
                        final item = showTags[index];
                        return ItemTags(
                          active: true,
                          key: Key(index.toString()),
                          index: index,
                          title: item,
                          textStyle: const TextStyle(
                              fontFamily: 'Mulish', fontSize: 17),
                          pressEnabled: false,
                          singleItem: false,
                          activeColor: Colors.blue,
                          color: Colors.grey,
                          onPressed: (i) {},
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
            TextButton.icon(
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
                            icon: Icon(Icons.cancel),
                            onPressed: () => Navigator.pop(context),
                          ),
                          createdQ = QuestionUICreate(),
                          TextButton(
                            onPressed: () {
                              counter++;
                              questions.add(createdQ);
                              Navigator.pop(context);
                              setState(() {
                                questionButtons.add(buildQTile(counter));
                              });
                            },
                            child: Text(
                              'Add',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                );
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
            ),
            Expanded(
              //bilo bi dobro kada bi ta predlozena pitanja bila neki gumbi pa bi se otvarao dijalog za potvrdu unosa pitanja
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: suggestedQ.length,
                itemBuilder: (BuildContext context, int index) {
                  return suggestedQ[index];
                },
                separatorBuilder: (BuildContext context, int index) {
                  return SizedBox(
                    width: 10,
                  );
                },
              ),
            ),
            Divider(
              color: Colors.grey[700],
              thickness: 2.0,
              height: 50,
            ),
            Expanded(
              flex: 5,
              child: ListView.separated(
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return questionButtons[index];
                },
                itemCount: questionButtons.length,
                separatorBuilder: (context, index) {
                  return SizedBox(
                    height: 15,
                  );
                },
                padding: EdgeInsets.only(left: 15, right: 15),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildQTile(int index) {
    int rowNum = index + 1;
    return (ListTile(
        leading: Text(
          rowNum.toString(),
          style: TextStyle(
              color: Colors.white, fontFamily: 'Mulish', fontSize: 22),
        ),
        title: Container(
          alignment: Alignment.center,
          child: Text(
            createdQ.getQuestion().questionText,
            style: TextStyle(
                color: Colors.white, fontFamily: 'Mulish', fontSize: 22),
            textAlign: TextAlign.center,
          ),
          decoration: BoxDecoration(
            color: Colors.lightBlue,
            border: Border.all(),
            borderRadius: BorderRadius.circular(10),
          ),
          height: 70,
          width: 80,
        ),
        onTap: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return Dialog(
                  child: questions[index],
                );
              });
        },
        trailing: IconButton(
          //bug popraviti da se broj red promijeni kada se izbriše pitanje
          icon: Icon(Icons.delete, color: Colors.white70),
          onPressed: () {
            setState(() {
              counter--;
              rowNum--;
              questionButtons.removeAt(index);
            });
          },
        )));
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

  List<String> showTagsUpdate(List<int> selectedTags) {
    List<String> showTags = [];
    selectedTags.forEach((element) {
      showTags.add(tags.elementAt(element).value);
    });
    return showTags;
  }
}
