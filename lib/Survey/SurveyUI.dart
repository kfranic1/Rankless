import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:intl/intl.dart';
import 'package:rankless/shared/Interface.dart';
import 'package:search_choices/search_choices.dart';
import 'Question.dart';
import 'QuestionUICreate.dart';
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
  DateFormat _formatted = DateFormat('dd-MM-yyyy');
  List<int> _selectedTags = [];
  QuestionUICreate _createdQ;
  List<QuestionUICreate> _questions = [];
  List<DropdownMenuItem> tags = [];
  final TextEditingController nameEditing = TextEditingController();
  bool loading = false;

  @override
  initState() {
    // nameEditing.addListener(() {
    //   setState(() {
    //
    //   });
    // });
    widget.survey.company.tags.forEach((element) {
      this.tags.add(DropdownMenuItem(child: Text(element), value: element));
    });
    widget.survey.company.positions.forEach((element) {
      this.tags.add(DropdownMenuItem(child: Text(element), value: element));
    });
    super.initState();
  }

  @override
  void dispose() {
    nameEditing.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //provjera za tagove
    final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();
    final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
    // ovo između služi samo za provjeru

    return Scaffold(
      key: _scaffoldKey,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).requestFocus(new FocusNode()),
        child: Container(
          decoration: backgroundDecoration,
          child: loading
              ? loader
              : Column(
                  children: <Widget>[
                    Container(
                      child: TextField(
                        controller: nameEditing,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: 'Name',
                          hintStyle: TextStyle(
                            fontFamily: font,
                            color: Colors.grey[600],
                            fontSize: 25,
                            //fontWeight: FontWeight.bold,
                          ),
                        ),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: font,
                          fontSize: 25,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      alignment: Alignment.topCenter,
                      padding: EdgeInsets.all(20),
                    ),
                    Container(
                      child: Row(
                        children: <Widget>[
                          //date
                          Text(
                            'Date',
                            style: header,
                          ),
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
                                  _formatted.format(widget.survey.from),
                                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, fontFamily: font, color: Colors.white),
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
                                  _formatted.format(widget.survey.to),
                                  style: TextStyle(fontFamily: font, fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
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
                            'For: ',
                            style: header,
                          ),
                          SizedBox(width: 20),
                          Expanded(
                            child: SearchChoices.multiple(
                              items: tags, //lista roles u klasi Company bi trebali biti DropDownMenuItem tipa
                              selectedItems: _selectedTags,
                              selectedValueWidgetFn: (item) {
                                return Container();
                              },
                              style: inputTextStyle,
                              icon: Icon(Icons.add_circle_outline),
                              underline: Container(),
                              onChanged: (value) {
                                setState(() {
                                  _selectedTags = value;
                                  widget.survey.tags = showTagsUpdate(_selectedTags);
                                });
                              },
                              menuBackgroundColor: Colors.black,
                              displayItem: (item, selected) {
                                return Column(children: [
                                  SizedBox(height: 20),
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
                                        style: inputTextStyle,
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
                                style: inputTextStyle.copyWith(fontWeight: FontWeight.bold),
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
                              itemCount: widget.survey.tags.length,
                              itemBuilder: (index) {
                                final item = widget.survey.tags[index];
                                return ItemTags(
                                  active: true,
                                  key: Key(index.toString()),
                                  index: index,
                                  title: item,
                                  textStyle: const TextStyle(fontFamily: font, fontSize: 17),
                                  pressEnabled: false,
                                  singleItem: false,
                                  activeColor: Colors.blue,
                                  color: Colors.grey,
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
                                addAutomaticKeepAlives: true,
                                children: [
                                  IconButton(
                                    icon: Icon(
                                      Icons.cancel,
                                      color: Colors.white,
                                    ),
                                    onPressed: () => Navigator.pop(context),
                                  ),
                                  _createdQ = QuestionUICreate(),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      setState(() {
                                        if (_createdQ.getQuestion().questionText != null) {
                                          _questions.add(_createdQ);
                                          widget.survey.qNa.add(_createdQ.getQuestion());
                                        }
                                      });
                                    },
                                    child: Text(
                                      'Add',
                                      style: header,
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
                        style: header,
                      ),
                    ),

                    //questions
                    Expanded(
                      flex: 5,
                      child: ListView.separated(
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return buildQTile(widget.survey.qNa[index], index);
                        },
                        itemCount: widget.survey.qNa.length,
                        separatorBuilder: (context, index) {
                          return SizedBox(
                            child: Divider(
                              color: Colors.white,
                            ),
                            height: 15,
                          );
                        },
                        padding: EdgeInsets.only(left: 15, right: 15),
                      ),
                    ),

                    //finish creating survey
                    TextButton(
                      onPressed: () async {
                        int error = -1;
                        int cnt = 0;
                        for (Question q in widget.survey.qNa) {
                          cnt++;
                          if (q.questionText == null || q.questionText.length == 0) error = cnt;
                          if (q.answerType == TYPE.Text) continue;
                          for (String ans in q.multipleAnswers) {
                            if (ans == null || ans.length == 0) error = cnt;
                          }
                        }
                        if (nameEditing.text == null || nameEditing.text.length == 0) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              "Survey doesn't have a name",
                              style: inputTextStyle.copyWith(fontSize: snackFontSize),
                            ),
                          ));
                        } else if (widget.survey.qNa.length == 0) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              "Survey is empty",
                              style: inputTextStyle.copyWith(fontSize: snackFontSize),
                            ),
                          ));
                        } else if (error != -1) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text(
                              "Question $error is not complete",
                              style: inputTextStyle.copyWith(fontSize: snackFontSize),
                            ),
                          ));
                        } else {
                          setState(() {
                            loading = true;
                          });
                          widget.survey.name = nameEditing.text;
                          await widget.survey.createSurvey();

                          Navigator.pop(context);
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: Colors.transparent,
                          borderRadius: borderRadius,
                        ),
                        height: 60,
                        width: 200,
                        child: Text(
                          'Finish',
                          style: TextStyle(
                              //fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: font,
                              fontSize: 22),
                        ),
                      ),
                    )
                  ],
                ),
        ),
      ),
    );
  }

//-----------------------------------------------------------------------------------------------------------
//-----------------------------------------------------------------------------------------------------------
//methods
  Widget buildQTile(Question question, int index) {
    return ListTile(
      leading: Text(
        (index + 1).toString(),
        style: header,
      ),
      title: Container(
        constraints: BoxConstraints(
          maxHeight: double.infinity,
        ),
        alignment: Alignment.centerLeft,
        padding: EdgeInsets.only(left: 10, right: 10),
        child: Text(
          question.questionText,
          style: header,
          textAlign: TextAlign.left,
        ),
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(style: BorderStyle.none),
          borderRadius: BorderRadius.circular(10),
        ),
        width: 80,
      ),
      trailing: IconButton(
        icon: Icon(
          Icons.delete,
          color: Colors.white,
        ),
        onPressed: () async {
          return await showDialog(
            context: context,
            builder: (BuildContext context) => AlertDialog(
              title: const Text(
                "Confirm",
                style: TextStyle(
                  fontFamily: font,
                  fontWeight: FontWeight.bold,
                ),
              ),
              content: const Text(
                "Are you sure you want to delete this question?",
                style: TextStyle(fontFamily: font),
              ),
              actions: <Widget>[
                TextButton(
                  onPressed: () {
                    setState(() {
                      _questions.removeAt(index);
                      widget.survey.qNa.removeAt(index);
                    });
                    Navigator.of(context).pop();
                  },
                  child: const Text(
                    "DELETE",
                    style: TextStyle(fontFamily: font),
                  ),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text(
                    "CANCEL",
                    style: TextStyle(fontFamily: font),
                  ),
                ),
              ],
            ),
          );
        },
      ),
      onTap: () {
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                insetPadding: EdgeInsets.only(left: 0.0, right: 0.0),
                backgroundColor: Colors.transparent,
                child: ListView(
                  children: [
                    _questions[index],
                    IconButton(
                        icon: Icon(
                          Icons.done,
                          color: Colors.white,
                          size: 40,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                          setState(() {
                            question = _questions[index].getQuestion();
                          });
                        }),
                  ],
                ),
              );
            });
      },
    );
  }

  _selectFrom(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: widget.survey.from,
      firstDate: widget.survey.from,
      lastDate: widget.survey.from.add(Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark(),
          child: child,
        );
      },
    );
    if (picked.isAfter(widget.survey.to)) return showAlertDialog(context);
    if (picked != null) setState(() => widget.survey.from = picked);
  }

  _selectTo(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: widget.survey.to,
      firstDate: widget.survey.from,
      lastDate: widget.survey.to.add(Duration(days: 365)),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark(),
          child: child,
        );
      },
    );
    if (picked.isBefore(widget.survey.from)) {
      return showAlertDialog(context);
    }
    if (picked != null && picked.isAfter(widget.survey.from)) setState(() => widget.survey.to = picked);
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
