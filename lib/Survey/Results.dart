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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: backgroundDecoration,
        child: FutureBuilder(
          future: widget.survey.getSurvey(true),
          builder: (context, snapshot) => snapshot.connectionState !=
                  ConnectionState.done
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
                    ListView.separated(
                      key: UniqueKey(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        if (widget.survey.qNa[index].answerType == TYPE.Text) {
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
                      itemCount: widget.survey.qNa.length,
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
                ),
        ),
      ),
    );
  }

  int countTextAns() {
    int cnt = 0;
    Map<String, Map<int, List<String>>> results =
        widget.survey.getResults(fake: true);
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

  Widget showTextQ(Question question, int index) {
    Map<String, Map<int, List<String>>> results =
        widget.survey.getResults(fake: true);
    String position;
    return ListView.separated(
      key: UniqueKey(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        results.forEach((key, value) {
          position = key;
          value.forEach((key, value) {
            if (key == index) {
              return Container(
                child: Column(children: [
                  Text(
                    position,
                    style: TextStyle(
                        fontFamily: font, fontSize: 12, color: Colors.white),
                    textAlign: TextAlign.left,
                  ),
                  Text(
                    value[index],
                    style: TextStyle(
                        fontFamily: font, fontSize: 15, color: Colors.white),
                    textAlign: TextAlign.left,
                  ),
                ]),
                color: Colors.blue,
              );
            }
          });
        });
      },
      itemCount: countTextAns(),
      separatorBuilder: (context, index) {
        return SizedBox(
          height: 20,
        );
      },
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
                x: 3,
                barRods: [
                  BarChartRodData(
                      y: 13,
                      colors: [Colors.lightBlueAccent, Colors.greenAccent])
                ],
                showingTooltipIndicators: [0],
              ),
              BarChartGroupData(
                x: 3,
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
