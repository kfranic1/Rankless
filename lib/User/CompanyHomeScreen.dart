import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rankless/Survey/Results.dart';
import 'package:rankless/Survey/Survey.dart';
import 'package:rankless/Survey/SurveyUI.dart';
import 'package:rankless/User/Employee.dart';
import 'package:rankless/shared/Interface.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'Company.dart';
import 'Manage.dart';

class CompanyHomeScreen extends StatefulWidget {
  @override
  _CompanyHomeScreenState createState() => _CompanyHomeScreenState();
}

class _CompanyHomeScreenState extends State<CompanyHomeScreen> {
  ListView requests;

  bool handling = false;
  bool imageLoading = false;
  int numOfSurveys = -1;
  Widget surveys;
  bool gettingSurveys = false;

  @override
  Widget build(BuildContext context) {
    final Company company = Provider.of<Company>(context);
    final Employee me = Provider.of<Employee>(context);
    if (!gettingSurveys && (surveys == null || numOfSurveys != company.surveys.length)) surveys = getSurveys(company);
    return Scaffold(
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: me.admin
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                me.admin
                    ? Expanded(
                        child: Stack(
                          clipBehavior: Clip.none,
                          alignment: AlignmentDirectional.topEnd,
                          children: [
                            FloatingActionButton(
                                heroTag: 'left',
                                backgroundColor: Colors.black.withOpacity(0.7),
                                child: Icon(
                                  Icons.group_add_rounded,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Manage(company)))),
                          ],
                        ),
                      )
                    : Container(),
                Expanded(
                  flex: 3,
                  child: Container(height: 0),
                ),
                Expanded(
                  child: Stack(
                    children: [
                      FloatingActionButton(
                        heroTag: 'right',
                        backgroundColor: Colors.black.withOpacity(0.7),
                        child: Icon(
                          Icons.post_add_rounded,
                          size: 30,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SurveyUI(new Survey(
                              name: '',
                              company: company,
                            )),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
          : Container(),
      body: Container(
        padding: EdgeInsets.all(10),
        width: double.infinity,
        height: double.infinity,
        decoration: backgroundDecoration,
        child: company.dummy || me.companyUid == null
            ? Center(
                child: Text(
                  'You are not in any company',
                  style: inputTextStyle,
                ),
              )
            : Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.all(30),
                      child: Text(
                        company.name,
                        style: titleNameStyle.copyWith(fontSize: nameFontSize),
                      ),
                    ),
                  ),
                  Container(
                    child: ListTile(
                      leading: Icon(
                        Icons.list,
                        color: Colors.white.withOpacity(0.4),
                        size: 40,
                      ),
                      title: Text(
                        company.industry,
                        style: TextStyle(
                          color: Colors.white,
                          fontFamily: font,
                          fontSize: 22,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  company.surveys.length == 0
                      ? Center(
                          child: Text(
                            "You don't have any completed surveys",
                            style: header,
                          ),
                        )
                      : Container(
                          margin: EdgeInsets.only(left: 20),
                          child: Text(
                            "Survey results:",
                            style: header,
                          ),
                        ),
                  SizedBox(height: 30),
                  surveys
                ],
              ),
      ),
    );
  }

  Widget getSurveys(Company company) {
    setState(() {
      gettingSurveys = true;
      numOfSurveys = company.surveys.length;
    });
    return Expanded(
      child: ListView.separated(
          physics: ClampingScrollPhysics(),
          shrinkWrap: true,
          itemBuilder: (context, index) => filledSurveys(company.surveys[index]),
          separatorBuilder: (context, index) => SizedBox(height: 20),
          itemCount: company.surveys.length),
    );
  }

  Widget filledSurveys(Survey survey) {
    DateFormat _formatted = DateFormat('dd-MM-yyyy');
    return FutureBuilder(
      future: survey.getSurvey(false),
      builder: (context, snapshot) => snapshot.connectionState != ConnectionState.done
          ? loader
          : Container(
              //width: 250,
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: borderRadius,
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.indigo, Colors.blue],
                ),
              ),
              child: TextButton.icon(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => Results(survey))),
                icon: Icon(
                  Icons.bar_chart_rounded,
                  color: Colors.greenAccent,
                  size: 50,
                ),
                label: Text(
                  survey.name + "\n" + (survey.status == STATUS.Active ? "active until: " : "ended: ") + _formatted.format(survey.to),
                  style: TextStyle(
                    fontFamily: font,
                    fontSize: 22,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
    );
  }
}
