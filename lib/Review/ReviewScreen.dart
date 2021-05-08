import 'dart:math';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rankless/User/Company.dart';
import 'package:rankless/User/Employee.dart';
import 'package:rankless/shared/Interface.dart';
import 'package:search_choices/search_choices.dart';
import 'Analysis.dart';

class ReviewScreen extends StatefulWidget {
  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  List<DropdownMenuItem<String>> searchCountries;
  String selectedCountry = 'global';
  List<DropdownMenuItem<String>> searchCategories = [];
  String selectedCategory;
  int selectedCategoryIndex = 5;
  bool yourIndustry = false;
  bool admin = false;
  String selectedIndustry;
  Company company;
  Analysis analysis;
  Future _future;
  List<Widget> strengths = [];
  List<Widget> averageCategories = [];
  List<Widget> weaknesses = [];
  int upperPercentageBound = 33;
  int lowerPercentageBound = 66;

  Color myColor = Colors.blue;
  Color avgColor = Colors.white;
  Color maxColor = Colors.greenAccent;

  Widget categoryRow = Padding(
      padding: EdgeInsets.only(top: 5),
      child: Column(
        children: [
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Text('Category', style: inputTextStyle.copyWith(fontWeight: FontWeight.bold)),
            Text(
              'Top',
              style: inputTextStyle.copyWith(fontWeight: FontWeight.bold),
            )
          ]),
          SizedBox(child: Divider(color: Colors.white), height: 15),
        ],
      ));

  @override
  void initState() {
    company = Provider.of<Company>(context, listen: false);
    analysis = Analysis(company.uid);
    _future = analysis.getData().whenComplete(() {
      searchCountries = analysis.activeCountries.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(value),
        );
      }).toList();
    });
    searchCategories = categories.map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(value: value, child: Text(value));
    }).toList();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    myColor = Colors.blue;
    avgColor = Colors.white;
    maxColor = Colors.greenAccent;
    admin = Provider.of<Employee>(context, listen: false).admin;

    return Scaffold(
      body: Container(
        decoration: backgroundDecoration,
        height: double.infinity,
        width: double.infinity,
        padding: EdgeInsets.all(10),
        child: company.dummy
            ? Container(
                decoration: backgroundDecoration,
                width: double.infinity,
                height: double.infinity,
                child: Center(child: Text('You are not in any company', style: inputTextStyle)),
              )
            : FutureBuilder(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) return loader;
                  strengths.clear();
                  averageCategories.clear();
                  weaknesses.clear();
                  strengths.add(categoryRow);
                  averageCategories.add(categoryRow);
                  weaknesses.add(categoryRow);
                  yourIndustry ? selectedIndustry = company.industry : selectedIndustry = null;
                  categories.forEach((cat) {
                    int percentage = analysis.getPosition(categories.indexOf(cat),
                        industry: selectedIndustry, country: selectedCountry == 'global' ? null : selectedCountry);
                    Widget el = Padding(
                      padding: EdgeInsets.only(top: 5),
                      child: Row(
                        children: [Text(cat, style: inputTextStyle), Text(percentage.toString() + ' %', style: inputTextStyle)],
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      ),
                    );
                    if (percentage < upperPercentageBound)
                      strengths.add(el);
                    else if (percentage > lowerPercentageBound)
                      weaknesses.add(el);
                    else
                      averageCategories.add(el);
                  });
                  ifEmptyAddNone(strengths);
                  ifEmptyAddNone(averageCategories);
                  ifEmptyAddNone(weaknesses);
                  return ListView(
                    shrinkWrap: true,
                    children: [
                      Container(
                        // padding: EdgeInsets.all(20),
                        // decoration: BoxDecoration(
                        //     border: Border.all(color: Colors.white),
                        //     borderRadius: borderRadius), //RoundedRectangleBorder(borderRadius: borderRadius))),
                        child: Column(
                          // mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Text('Filters: ', style: inputTextStyle),
                            Container(
                              padding: EdgeInsets.only(left: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Industry: ' + (yourIndustry ? company.industry : 'All'),
                                    style: inputTextStyle, //.copyWith(fontSize: 20),
                                  ),
                                  Switch(
                                    value: yourIndustry,
                                    onChanged: (bool value) {
                                      setState(() {
                                        yourIndustry = value;
                                      });
                                    },
                                    // trackColor: MaterialStateProperty.all<Color>(Colors.grey),
                                    inactiveTrackColor: Colors.grey,
                                    activeTrackColor: primaryBlue.withOpacity(0.7),
                                  ),
                                ],
                              ),
                            ),

                            // country search
                            Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                SizedBox(child: Divider(color: Colors.white), height: 10),
                                SearchChoices.single(
                                    isExpanded: true,
                                    icon: Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.white,
                                    ),
                                    clearIcon: Icon(
                                      Icons.clear,
                                      color: Colors.white,
                                    ),
                                    iconSize: 30,
                                    underline: Container(),
                                    menuBackgroundColor: Colors.black,
                                    items: searchCountries,
                                    value: selectedCountry,
                                    style: inputTextStyle,
                                    hint: Text(
                                      'Global',
                                      style: inputTextStyle,
                                    ),
                                    // isExpanded: true,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedCountry = value;
                                      });
                                    },
                                    onClear: () {
                                      setState(() {
                                        selectedCountry = 'global';
                                      });
                                    },
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
                                                  Icons.radio_button_off_outlined,
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
                                    }),
                                SizedBox(child: Divider(color: Colors.white), height: 10),
                                // category search
                                SearchChoices.single(
                                    isExpanded: true,
                                    icon: Icon(
                                      Icons.arrow_drop_down,
                                      color: Colors.white,
                                    ),
                                    clearIcon: Icon(
                                      Icons.clear,
                                      color: Colors.white,
                                    ),
                                    iconSize: 30,
                                    underline: Container(),
                                    menuBackgroundColor: Colors.black,
                                    items: searchCategories,
                                    value: selectedCategory,
                                    style: inputTextStyle,
                                    hint: Text(
                                      'Total score',
                                      style: inputTextStyle,
                                    ),
                                    // isExpanded: true,
                                    onChanged: (value) {
                                      setState(() {
                                        selectedCategory = value == -1 ? 5 : value;
                                        selectedCategoryIndex = value == null ? 5 : categories.indexOf(value);
                                      });
                                    },
                                    onClear: () {
                                      setState(() {
                                        selectedCategory = 'Total score';
                                        selectedCategoryIndex = 5;
                                      });
                                    },
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
                                                  Icons.radio_button_off_outlined,
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
                                    }),
                                SizedBox(child: Divider(color: Colors.white), height: 10),
                              ],
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20),
                      Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
                        Container(
                          child: Row(
                            children: [
                              Icon(
                                Icons.remove,
                                color: myColor,
                              ),
                              Text(
                                'Your score',
                                style: inputTextStyle,
                              ),
                            ],
                          ),
                        ),
                        if (admin)
                          Container(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.remove,
                                  color: avgColor,
                                ),
                                Text(
                                  'Average',
                                  style: inputTextStyle,
                                ),
                              ],
                            ),
                          ),
                        if (admin)
                          Container(
                            child: Row(
                              children: [
                                Icon(
                                  Icons.remove,
                                  color: maxColor,
                                ),
                                Text(
                                  'Top',
                                  style: inputTextStyle,
                                ),
                              ],
                            ),
                          ),
                      ]),
                      getGraph(selectedCategoryIndex, country: selectedCountry == 'global' ? null : selectedCountry, industry: selectedIndustry),
                      if (admin) adminExtraData()
                    ],
                  );
                }),
      ),
    );
  }

  Widget adminExtraData() {
    return ListView(
      shrinkWrap: true,
      physics: ClampingScrollPhysics(),
      children: [
        Container(
          padding: EdgeInsets.all(15),
          // height: 100,
          decoration: BoxDecoration(
              borderRadius: borderRadius,
              gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.teal[600], Colors.blue[700]])),
          child: Column(children: [
            Text('Your Strenghts:', style: inputTextStyle.copyWith(fontWeight: FontWeight.bold)),
            ListView.builder(
              itemCount: strengths.length,
              itemBuilder: (context, index) {
                return strengths[index];
              },
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
            )
          ]),
        ),
        SizedBox(height: 20),
        Container(
          padding: EdgeInsets.all(15),
          // height: 100,
          decoration: BoxDecoration(borderRadius: borderRadius, color: Colors.indigo[900]),
          child: Column(
            children: [
              Text('Average:', style: inputTextStyle.copyWith(fontWeight: FontWeight.bold)),
              ListView.builder(
                itemCount: averageCategories.length,
                itemBuilder: (context, index) {
                  return averageCategories[index];
                },
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
              )
            ],
          ),
        ),
        SizedBox(height: 20),
        Container(
          padding: EdgeInsets.all(15),
          // height: 100,
          decoration: BoxDecoration(
              borderRadius: borderRadius,
              gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.red[900], Colors.pink[900]])),
          child: Column(
            children: [
              Text('Your weaknesses:', style: inputTextStyle.copyWith(fontWeight: FontWeight.bold)),
              ListView.builder(
                itemCount: weaknesses.length,
                itemBuilder: (context, index) {
                  return weaknesses[index];
                },
                physics: ClampingScrollPhysics(),
                shrinkWrap: true,
              )
            ],
          ),
        ),
        SizedBox(height: 20),
        Container(
          height: 140,
          child: ListView.separated(
            separatorBuilder: (context, index) {
              return SizedBox(width: 20);
            },
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              return Container(
                height: 100,
                width: 250,
                decoration: BoxDecoration(borderRadius: borderRadius, color: Colors.indigo[900]),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(categories[index], style: inputTextStyle.copyWith(fontWeight: FontWeight.bold)),
                          IconButton(
                              icon: Icon(
                                Icons.info_outline,
                                color: Colors.white54,
                              ),
                              onPressed: () => showDialog(
                                  context: context,
                                  builder: (context) => StatefulBuilder(
                                      builder: (context, setState) => Dialog(
                                            backgroundColor: primaryBlue,
                                            shape: dialogShape,
                                            child: Container(
                                                padding: EdgeInsets.all(10),
                                                child: Text(
                                                  categoryDescriptions[index],
                                                  style: inputTextStyle,
                                                )),
                                          ))))
                        ],
                      ),
                      SizedBox(height: 10),
                      Text(
                        analysis.getMessage(index, country: selectedCountry == 'global' ? null : selectedCountry, industry: selectedIndustry),
                        style: inputTextStyle,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget getGraph(int category, {String country, String industry}) {
    return GestureDetector(
      onHorizontalDragUpdate: (_) {},
      child: Container(
        padding: EdgeInsets.only(right: 20, top: 25, bottom: 25),
        height: 400,
        child: LineChart(
          LineChartData(
            lineTouchData: LineTouchData(
              touchTooltipData: LineTouchTooltipData(
                tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
              ),
              touchCallback: (LineTouchResponse touchResponse) {},
              handleBuiltInTouches: true,
            ),
            gridData: FlGridData(
              show: false,
            ),
            titlesData: FlTitlesData(
              bottomTitles: SideTitles(
                showTitles: true,
                reservedSize: 22,
                getTextStyles: (value) => const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
                margin: 10,
                getTitles: (value) {
                  int val = value.round() + analysis.getFirstMonth();
                  if (val % 3 != analysis.getFirstMonth() % 3 &&
                      val != min(12, analysis.getNumOfSurveys().toDouble()) &&
                      analysis.getNumOfSurveys() > 3) return '';
                  if (value <= analysis.getNumOfSurveys()) return months[val % 12];
                  return '';
                },
              ),
              leftTitles: SideTitles(
                showTitles: true,
                getTextStyles: (value) => const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
                getTitles: (value) {
                  return value.toString();
                },
                margin: 8,
                reservedSize: 30,
              ),
            ),
            borderData: FlBorderData(
              show: true,
              border: const Border(
                bottom: BorderSide(
                  color: Colors.white,
                  width: 1,
                ),
                left: BorderSide(
                  color: Colors.white,
                ),
                right: BorderSide(
                  color: Colors.transparent,
                ),
                top: BorderSide(
                  color: Colors.transparent,
                ),
              ),
            ),
            minX: 0,
            maxX: min(12, analysis.getNumOfSurveys().toDouble()),
            minY: 0,
            maxY: 5,
            lineBarsData: linesBarData(category, country: country, industry: industry),
          ),
        ),
      ),
    );
  }

  List<LineChartBarData> linesBarData(int questionCategory, {String country, String industry}) {
    List<FlSpot> myScore = [], avgScore = [], maxScore = [];
    for (int i = 0; i < analysis.getNumOfSurveys(); i++) {
      avgScore.add(FlSpot(i.toDouble(), analysis.getAvgScore(i, questionCategory, country: country, industry: industry)));
      maxScore.add(FlSpot(i.toDouble(), analysis.getMaxScore(i, questionCategory, country: country, industry: industry)));
      myScore.add(FlSpot(i.toDouble(), analysis.getMyScore(i, questionCategory)));
    }
    final LineChartBarData avg = LineChartBarData(
      spots: avgScore,
      isCurved: true,
      colors: [
        avgColor,
      ],
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
    final LineChartBarData max = LineChartBarData(
      spots: maxScore,
      isCurved: true,
      colors: [
        maxColor,
      ],
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(show: false, colors: [
        const Color(0x00aa4cfc),
      ]),
    );
    final LineChartBarData my = LineChartBarData(
      spots: myScore,
      isCurved: true,
      colors: [
        myColor,
      ],
      barWidth: 3,
      isStrokeCapRound: true,
      dotData: FlDotData(
        show: false,
      ),
      belowBarData: BarAreaData(
        show: false,
      ),
    );
    return admin ? [avg, max, my] : [my];
  }

  void ifEmptyAddNone(List<Widget> list) {
    if (list.length == 1) {
      list.clear();
      list.add(Row(
        children: [Text('None', style: inputTextStyle), Text('')],
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
      ));
    }
  }
}
