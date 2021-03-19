import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:rankless/Survey/Question.dart';
import 'package:rankless/Survey/Survey.dart';
import 'package:rankless/shared/Interface.dart';

class Results extends StatefulWidget {
  final Survey survey;
  Results(this.survey);

  @override
  _ResultsState createState() => _ResultsState();
}

class _ResultsState extends State<Results> {
  Map<String, Map<int, List<String>>> results;
  Future _future;

  @override
  void initState() {
    _future = widget.survey.getSurvey(true).whenComplete(() {
      setState(() {
        print('here');
        results = widget.survey.getResults();
        print(results);
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //appBar: AppBar(),
      body: Container(
        decoration: backgroundDecoration,
        child: FutureBuilder(
          future: _future,
          builder: (context, snapshot) {
            print(snapshot.connectionState);
            return snapshot.connectionState != ConnectionState.done
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                //TU IDE WIDGET
                : Column(
                    children: [
                      Container(
                        child: Text(
                          widget.survey.name,
                          style: surveyNameStyle,
                        ),
                        alignment: Alignment.topCenter,
                        padding: EdgeInsets.all(20),
                      ),
                      Expanded(
                        child: ListView.separated(
                          key: UniqueKey(),
                          shrinkWrap: true,
                          itemCount: widget.survey.qNa.length,
                          itemBuilder: (context, index) {
                            print(widget.survey.qNa[index].answerType);
                            if (widget.survey.qNa[index].answerType ==
                                TYPE.Text) {
                              return showTextQ(widget.survey.qNa[index], index);
                            }
                            if (widget.survey.qNa[index].answerType ==
                                TYPE.RadioButton) {
                              return showRadioQ(widget.survey.qNa[index]);
                            }
                            return null;
                          },
                          separatorBuilder: (context, index) {
                            return SizedBox(
                              height: 20,
                            );
                          },
                        ),
                      ),
                      TextButton(
                        child: Text(
                          'Done',
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: font,
                              fontSize: 20),
                        ),
                        onPressed: () {},
                      ),
                    ],
                  );
          },
        ),
      ),
    );
  }

  int countTextAns() {
    int cnt = 0;
    for (int i = 0; i < widget.survey.qNa.length; i++) {
      if (widget.survey.qNa[i].answerType == TYPE.Text) {
        results.forEach((key, value) {
          value.forEach((key, value) {
            if (key == i) {
              cnt += value.length;
            }
          });
        });
      }
    }
    return cnt;
  }

  Widget showTextQ(Question question, int questionNum) {
    return ListTile(
      tileColor: Colors.white,
      title: Row(
        children: [
          Expanded(
              //alignment: Alignment.topCenter,
              child: Text(
                  (questionNum + 1).toString() + '. ' + question.questionText)),
          TextButton(
            child: Text('See all'),
            onPressed: () {
              setState(() {
                showDialog(
                  context: context,
                  builder: (context) => showAll(question, questionNum),
                );
              });
            },
          ),
        ],
      ),
      subtitle: ListView.separated(
        physics: ClampingScrollPhysics(),
        shrinkWrap: true,
        itemCount: results.length,
        itemBuilder: (context, index) {
          String position = results.keys.toList()[index];
          return ListTile(
            title: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: Text(position),
            ),
            subtitle: Text(results[position][questionNum][0]),
          );
        },
        separatorBuilder: (context, index) => Divider(),
      ),
    );
  }

  Widget showAll(Question question, int questionNum) {
    return Dialog(
      child: Container(
        constraints: BoxConstraints(maxHeight: 300),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Text(
                    (questionNum + 1).toString() + '. ' + question.questionText,
                  )
                ],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ),
            Expanded(
              child: Container(
                child: RawScrollbar(
                  isAlwaysShown: true,
                  thumbColor: Colors.black,
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: results.length,
                    itemBuilder: (context, index) {
                      String position = results.keys.toList()[index];
                      return ListView.separated(
                          physics: ClampingScrollPhysics(),
                          shrinkWrap: true,
                          itemBuilder: (context, index2) => ListTile(
                                title: Padding(
                                  padding: const EdgeInsets.only(bottom: 10.0),
                                  child: Text(position),
                                ),
                                subtitle: Text(
                                    results[position][questionNum][index2]),
                              ),
                          itemCount: results[position][questionNum].length,
                          separatorBuilder: (context, index) => Divider());
                    },
                    separatorBuilder: (context, index) => Divider(),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget showRadioQ(Question question) {
    return AspectRatio(
      aspectRatio: 1.7,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        color: const Color(0xff2c4260),
        child: BarChart(
          BarChartData(
            alignment: BarChartAlignment.spaceAround,
            maxY: 20,
            barTouchData: BarTouchData(
              enabled: false,
              touchTooltipData: BarTouchTooltipData(
                tooltipBgColor: Colors.transparent,
                tooltipPadding: const EdgeInsets.all(0),
                tooltipBottomMargin: 8,
                getTooltipItem: (
                  BarChartGroupData group,
                  int groupIndex,
                  BarChartRodData rod,
                  int rodIndex,
                ) {
                  return BarTooltipItem(
                    rod.y.round().toString(),
                    TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  );
                },
              ),
            ),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: SideTitles(
                showTitles: true,
                getTextStyles: (value) => const TextStyle(
                    color: Color(0xff7589a2),
                    fontWeight: FontWeight.bold,
                    fontSize: 14),
                margin: 20,
                getTitles: (double value) {
                  switch (value.toInt()) {
                    case 0:
                      return 'Mn';
                    case 1:
                      return 'Te';
                    case 2:
                      return 'Wd';
                    case 3:
                      return 'Tu';
                    case 4:
                      return 'Fr';
                    case 5:
                      return 'St';
                    case 6:
                      return 'Sn';
                    default:
                      return '';
                  }
                },
              ),
              leftTitles: SideTitles(showTitles: false),
            ),
            borderData: FlBorderData(
              show: false,
            ),
            barGroups: [
              BarChartGroupData(
                x: 0,
                barRods: [
                  BarChartRodData(
                      y: 8,
                      colors: [Colors.lightBlueAccent, Colors.greenAccent])
                ],
                showingTooltipIndicators: [0],
              ),
              BarChartGroupData(
                x: 1,
                barRods: [
                  BarChartRodData(
                      y: 10,
                      colors: [Colors.lightBlueAccent, Colors.greenAccent])
                ],
                showingTooltipIndicators: [0],
              ),
              BarChartGroupData(
                x: 2,
                barRods: [
                  BarChartRodData(
                      y: 14,
                      colors: [Colors.lightBlueAccent, Colors.greenAccent])
                ],
                showingTooltipIndicators: [0],
              ),
              BarChartGroupData(
                x: 3,
                barRods: [
                  BarChartRodData(
                      y: 15,
                      colors: [Colors.lightBlueAccent, Colors.greenAccent])
                ],
                showingTooltipIndicators: [0],
              ),
              BarChartGroupData(
                x: 4,
                barRods: [
                  BarChartRodData(
                      y: 13,
                      colors: [Colors.lightBlueAccent, Colors.greenAccent])
                ],
                showingTooltipIndicators: [0],
              ),
              BarChartGroupData(
                x: 5,
                barRods: [
                  BarChartRodData(
                      y: 10,
                      colors: [Colors.lightBlueAccent, Colors.greenAccent])
                ],
                showingTooltipIndicators: [0],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
