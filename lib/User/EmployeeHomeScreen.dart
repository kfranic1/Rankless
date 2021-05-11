import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rankless/Survey/SurveyUIFill.dart';
import 'package:rankless/shared/Interface.dart';
import 'Company.dart';
import 'CreateCompany.dart';
import 'package:rankless/Survey/Survey.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

import 'Employee.dart';

double detailsSize = 22.0;

class EmployeeHomeScreen extends StatefulWidget {
  @override
  _EmployeeHomeScreenState createState() => _EmployeeHomeScreenState();
}

class _EmployeeHomeScreenState extends State<EmployeeHomeScreen> {
  //bool isCancelDisabled = false;
  TextEditingController joinController = new TextEditingController();
  int numOfSurveys = -1;
  Widget surveys;
  bool loading = false;

  @override
  void dispose() {
    joinController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Company company = Provider.of<Company>(context);
    final Employee employee = Provider.of<Employee>(context);
    surveys = surveys == null || numOfSurveys != employee.surveys.length ? getSurveys(employee, company.industry, company.country) : surveys;
    return Container(
      decoration: backgroundDecoration,
      padding: EdgeInsets.all(10),
      child: loading || (employee.dummy || (employee.companyUid != null && company.dummy))
          ? loader
          : Column(
              children: [
                Container(
                  alignment: Alignment.centerLeft,
                  padding: EdgeInsets.all(30),
                  child: Text(
                    employee.name + " " + employee.surname,
                    style: titleNameStyle.copyWith(fontSize: nameFontSize),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis, // ako bude jos dulje, bit ce ...
                  ),
                ),
                SizedBox(height: 20),
                employee.companyUid == null
                    ? ListView(
                        shrinkWrap: true,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: joinController,
                                  style: TextStyle(color: Colors.white),
                                  decoration: registerInputDecoration.copyWith(labelText: 'Company code'),
                                ),
                              ),
                              IconButton(
                                  icon: Icon(
                                    Icons.copy,
                                    color: Colors.grey,
                                  ),
                                  onPressed: () async {
                                    joinController.text = (await Clipboard.getData('text/plain')).text;
                                  }),
                              TextButton(
                                onPressed: () {
                                  setState(() => loading = true);
                                  employee.joinCompany(joinController.text).then((value) {
                                    if (value == "Error")
                                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                        content: Text(
                                          "Company with that code doesn't exist",
                                          style: TextStyle(fontFamily: font, fontSize: snackFontSize),
                                        ),
                                        duration: Duration(seconds: 2),
                                      ));
                                    setState(() => loading = false);
                                  });
                                },
                                child: Text('Join'),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          TextButton(
                            child: Text(
                              "Create Company",
                              style: TextStyle(
                                fontFamily: font,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => CreateCompany(employee),
                              ),
                            ),
                            style: textButtonStyleRegister,
                          ),
                        ],
                      )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.home_rounded,
                                color: Colors.white.withOpacity(0.4),
                                size: 40,
                              ),
                              SizedBox(width: 10),
                              Text(
                                company.name,
                                style: inputTextStyle.copyWith(fontSize: detailsSize),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.home_repair_service_rounded,
                                color: Colors.white.withOpacity(0.4),
                                size: 40,
                              ),
                              SizedBox(width: 10),
                              Text(
                                employee.position == '' ? 'No position' : employee.position,
                                overflow: TextOverflow.fade,
                                softWrap: false,
                                style: inputTextStyle.copyWith(fontSize: detailsSize),
                              )
                            ],
                          ),
                          SizedBox(height: 20),
                          Align(
                            alignment: Alignment.center,
                            child: TextButton(
                              style: textButtonStyleRegister,
                              child: Text(
                                'My tags',
                                style: inputTextStyle.copyWith(fontSize: detailsSize),
                              ),
                              onPressed: () {
                                showDialog(
                                  context: context,
                                  //Koristi widget.survey.results jer su results u ovom widgetu podlozni filterima
                                  builder: (context) => Dialog(
                                    child: Container(
                                      padding: EdgeInsets.all(25),
                                      height: 300,
                                      color: Colors.blue,
                                      child: employee.tags.isNotEmpty
                                          ? ListView.separated(
                                              itemBuilder: (context, index) {
                                                return Text(
                                                  employee.tags[index],
                                                  style: inputTextStyle.copyWith(fontSize: detailsSize),
                                                );
                                              },
                                              itemCount: employee.tags.length,
                                              separatorBuilder: (context, index) => SizedBox(height: 20),
                                            )
                                          : Text(
                                              'You don\'t have any tags',
                                              style: header,
                                            ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ),
                SizedBox(height: 20),
                Container(
                  //padding: EdgeInsets.only(left: 25),
                  alignment: Alignment.center,
                  child: Text(
                    employee.surveys.length > 0 ? 'Surveys:' : 'There are no new surveys',
                    style: inputTextStyle.copyWith(fontSize: detailsSize),
                  ),
                ),
                SizedBox(height: 30),
                Expanded(child: surveys),
              ],
            ),
    );
  }

  Widget getSurveys(Employee employee, String industry, String country) {
    setState(() => numOfSurveys = employee.surveys.length);
    return FutureBuilder(
      future: employee.handleSurveys(),
      builder: (context, snapshot) => snapshot.connectionState != ConnectionState.done
          ? loader
          : ListView.separated(
              physics: ClampingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) => activeSurveys(employee.surveys[index], employee, industry, country),
              separatorBuilder: (context, index) => SizedBox(height: 20),
              itemCount: employee.surveys.length,
            ),
    );
  }

  Widget activeSurveys(Survey survey, Employee employee, String industry, String country) {
    DateFormat _formatted = DateFormat('dd-MM-yyyy');
    return Container(
      // padding: ,
      //height: ,
      // width: 200,
      decoration: BoxDecoration(
        color: Colors.blue[50],
        borderRadius: borderRadius,
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: survey.isPublic ? [Colors.teal[600], Colors.cyan] : [Colors.indigo, Colors.blue],
        ),
      ),
      child: TextButton.icon(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                //fullscreenDialog: true,
                builder: (context) => SurveyUIFill(
                  survey,
                  employee,
                  industry: industry,
                  country: country,
                ),
              ));
        },
        icon: Icon(
          Icons.bar_chart_rounded,
          color: Colors.greenAccent,
          size: 50,
        ),
        label: Text(
          survey.name + "\n" + "until: " + _formatted.format(survey.to),
          style: TextStyle(fontFamily: font, fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
