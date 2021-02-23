import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
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
  @override
  Widget build(BuildContext context) {
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
            child: TextField(
              decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: this.survey.name,
                  hintStyle: TextStyle(
                    color: Colors.white,
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
            child: Row(
              children: <Widget>[
                Text('Date',
                    style: TextStyle(fontSize: 20, color: Colors.white)),
                SizedBox(
                  width: 20,
                ),
                FlatButton(
                  child: Text(
                    "${selectedFrom.toLocal()}".split(' ')[0],
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  onPressed: () => _selectFrom(context),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: Colors.white),
                  ),
                ),
                SizedBox(
                  child: Divider(
                    color: Colors.white,
                    indent: 7,
                    endIndent: 7,
                    thickness: 5,
                  ),
                  width: 30,
                ),
                FlatButton(
                  child: Text(
                    "${selectedFrom.toLocal()}".split(' ')[0],
                    style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  onPressed: () => _selectFrom(context),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide(color: Colors.white),
                  ),
                ),
              ],
            ),
            alignment: Alignment.bottomLeft,
            margin: EdgeInsets.only(left: 25),
          )
        ],
      ),
    ));
  }

  _selectFrom(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: selectedFrom,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark(),
          child: child,
        );
      },
    );
    if (picked != null && picked != this.survey.from)
      setState(() {
        selectedFrom = picked;
        this.survey.from = selectedFrom;
      });
  }
}
