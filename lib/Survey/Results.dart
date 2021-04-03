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
    _future = widget.survey.getSurvey(true).whenComplete(() => setState(() => results = widget.survey.getResults()));
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
            return snapshot.connectionState != ConnectionState.done
                ? loader
                : Column(
                    children: [
                      Container(
                        child: Text(
                          widget.survey.name,
                          style: titleNameStyle,
                        ),
                        alignment: Alignment.topCenter,
                        padding: EdgeInsets.all(20),
                      ),
                      Expanded(
                        child: ListView.separated(
                          shrinkWrap: true,
                          itemCount: widget.survey.qNa.length,
                          itemBuilder: (context, index) => Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: widget.survey.qNa[index].answerType == TYPE.Text
                                ? showTextQ(widget.survey.qNa[index], index)
                                : showGraphQ(widget.survey.qNa[index], index),
                          ),
                          separatorBuilder: (context, index) => SizedBox(height: 20),
                        ),
                      ),
                      TextButton(
                        child: Text(
                          'Done',
                          style: TextStyle(color: Colors.white, fontFamily: font, fontSize: 20),
                        ),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ],
                  );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.filter_alt_outlined),
        onPressed: () => showDialog(
          context: context,
          //Koristi widget.survey.results jer su results u ovom widgetu podlozni filterima
          builder: (context) => Dialog(
            child: Container(
              height: 300,
              child: ListView.builder(
                itemCount: widget.survey.results.length + 1,
                itemBuilder: (context, index) {
                  return Card(
                    child: index < widget.survey.results.length
                        ? TextButton(
                            child: Text(widget.survey.results.keys.toList()[index]),
                            onPressed: () {
                              Navigator.pop(context);
                              setState(() => results = widget.survey.getResults(filter: [widget.survey.results.keys.toList()[index]]));
                            },
                          )
                        : TextButton(
                            child: Text('Remove filters'),
                            onPressed: () {
                              Navigator.pop(context);
                              setState(() => results = widget.survey.getResults());
                            },
                          ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget showTextQ(Question question, int questionNum) {
    return Theme(
      data: ThemeData.dark(),
      child: ListTile(
        tileColor: const Color(0xff2c4260),
        title: Row(
          children: [
            Expanded(child: Text((questionNum + 1).toString() + '. ' + question.questionText)),
            TextButton(
              child: Text('See all'),
              onPressed: () => showDialog(
                context: context,
                builder: (context) => showAllDialog(question, questionNum),
              ),
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
      ),
    );
  }

  Widget showAllDialog(Question question, int questionNum) {
    return Dialog(
      child: Container(
        constraints: BoxConstraints(maxHeight: 300),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [Text((questionNum + 1).toString() + '. ' + question.questionText)],
                mainAxisAlignment: MainAxisAlignment.center,
              ),
            ),
            Expanded(
              child: Container(
                child: RawScrollbar(
                  isAlwaysShown: true,
                  thumbColor: Colors.black54,
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
                              subtitle: Text(results[position][questionNum][index2])),
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

  Widget showGraphQ(Question question, int questionNum) {
    List<int> values = List.generate(question.multipleAnswers.length, (index) => 0);
    for (String key in results.keys) {
      List<int> temp = results[key][questionNum].map((e) => int.parse(e)).toList();
      for (int mask in temp) {
        for (int i = 0; i < question.multipleAnswers.length; i++) if (mask & (1 << i) != 0) values[i]++;
      }
    }
    return Container(
      color: const Color(0xff2c4260),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        title: Padding(
          padding: const EdgeInsets.only(bottom: 10.0),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  (questionNum + 1).toString() + '. ' + question.questionText,
                  style: TextStyle(color: Colors.white),
                ),
              ),
              TextButton(
                  onPressed: () => showDialog(
                        context: context,
                        builder: (context) => answers(question, questionNum),
                      ),
                  child: Text('Answers')),
            ],
          ),
        ),
        subtitle: Container(
          height: 300,
          child: BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: values.fold(0, (previousValue, element) => previousValue > element ? previousValue : element) * 1.2,
              barTouchData: BarTouchData(
                enabled: false,
                touchTooltipData: BarTouchTooltipData(
                  tooltipBgColor: Colors.transparent,
                  tooltipPadding: const EdgeInsets.all(0),
                  tooltipMargin: 8,
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
                  getTextStyles: (value) => const TextStyle(color: Color(0xff7589a2), fontWeight: FontWeight.bold, fontSize: 14),
                  margin: 0,
                  getTitles: (double value) {
                    return (value + 1).toInt().toString();
                  },
                ),
                leftTitles: SideTitles(showTitles: false),
              ),
              borderData: FlBorderData(show: false),
              barGroups: values
                  .asMap()
                  .map(
                    (index, e) => MapEntry(
                      index,
                      BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            y: e != 0 ? e.toDouble() : 0.000001,
                            colors: [Colors.lightBlueAccent, Colors.greenAccent],
                          ),
                        ],
                        showingTooltipIndicators: [0],
                      ),
                    ),
                  )
                  .values
                  .toList(),
            ),
          ),
        ),
      ),
    );
  }

  Widget answers(Question question, int questionNum) {
    return Dialog(
      child: Container(
          constraints: BoxConstraints(maxHeight: 300),
          child: RawScrollbar(
            thumbColor: Colors.black54,
            isAlwaysShown: true,
            child: ListView.separated(
              itemBuilder: (context, index) => ListTile(
                leading: Text((index + 1).toString()),
                title: Text(question.multipleAnswers[index]),
              ),
              separatorBuilder: (context, index) => Divider(),
              itemCount: question.multipleAnswers.length,
            ),
          )),
    );
  }
}
