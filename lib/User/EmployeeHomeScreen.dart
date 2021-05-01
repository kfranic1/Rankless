import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:rankless/Survey/SurveyUIFill.dart';
import 'package:rankless/shared/Interface.dart';
import 'Company.dart';
import 'CreateCompany.dart';
import 'package:rankless/Survey/Survey.dart';
import 'JoinCompany.dart';
import 'package:intl/intl.dart';

import 'Employee.dart';

double detailsSize = 22.0;

class EmployeeHomeScreen extends StatefulWidget {
  @override
  _EmployeeHomeScreenState createState() => _EmployeeHomeScreenState();
}

class _EmployeeHomeScreenState extends State<EmployeeHomeScreen> {
  bool isCancelDisabled = false;
  bool imageLoading = false;
  int numOfSurveys = -1;
  Widget surveys;

  @override
  Widget build(BuildContext context) {
    final Company company = Provider.of<Company>(context);
    final Employee employee = Provider.of<Employee>(context);
    surveys = surveys == null || numOfSurveys != employee.surveys.length ? getSurveys(employee) : surveys;
    return employee.companyUid != null && company == null
        ? loader
        : Container(
            decoration: backgroundDecoration,
            padding: EdgeInsets.all(10),
            child: ListView(
              children: [
                Row(
                  children: [
                    IconButton(
                      iconSize: 100,
                      icon: imageLoading
                          ? loader
                          : Container(
                              alignment: Alignment.topLeft,
                              // padding: EdgeInsets.all(10),

                              child: CircleAvatar(
                                radius: 50, //should be half of icon size
                                backgroundImage: employee.image == null ? null : employee.image,
                                child: employee.image == null
                                    ? Text(
                                        (employee.name[0] + employee.surname[0]).toUpperCase(),
                                        style: TextStyle(fontSize: 25, fontFamily: font, letterSpacing: 2.0),
                                      )
                                    : null,
                              )),
                      onPressed: () async {
                        setState(() => imageLoading = true);
                        await employee.changeImage();
                        setState(() => imageLoading = false);
                      },
                    ),
                    // Container(
                    // padding: EdgeInsets.only(left: 20.0),
                    // width: 230,
                    // child:
                    // Column(
                    //     children: [
                    //       Text(
                    //         employee.name,
                    //         style: surveyNameStyle,
                    //         // inputTextStyle.copyWith(
                    //         // fontWeight: FontWeight.bold, ),
                    //       ),
                    //       Text(
                    //         employee.surname,
                    //         style: surveyNameStyle,
                    //       )
                    //     ],
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     crossAxisAlignment: CrossAxisAlignment.start,
                    //   ),
                    // ),
                    SizedBox(width: 20),
                    Expanded(
                      // flex: 2,
                      child: Text(
                        employee.name + " " + employee.surname,
                        style: titleNameStyle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis, // ako bude jos dulje, bit ce ...
                      ),
                    ),
                    // ),
                  ],
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,     // htjela sam umjesto SizedBoxa, ali ne radi
                ),
                SizedBox(height: 20),
                employee.companyUid == null
                    ? employee.request != '' && employee.request != 'denied'
                        ? Column(
                            children: [
                              Text("You sent request to " + employee.request.substring(employee.request.indexOf('%') + 1), style: inputTextStyle),
                              SizedBox(height: 20),
                              isCancelDisabled
                                  ? Container()
                                  : TextButton(
                                      onPressed: () async {
                                        setState(() => isCancelDisabled = true);
                                        await employee.cancelRequestToCompany();
                                        setState(() => isCancelDisabled = false);
                                      },
                                      child: Text("Cancel request", style: inputTextStyle),
                                      style: textButtonStyleRegister,
                                    ),
                            ],
                          )
                        : Row(
                            children: [
                              //TODO stilizirat ovaj text ispod jer je nedavno dodan
                              if (employee.request == 'denied') Text('Your last request was denied.'),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: TextButton(
                                    child: Text(
                                      "Create Company",
                                      style: TextStyle(fontFamily: font, fontSize: 15, fontWeight: FontWeight.bold, color: Colors.white),
                                    ),
                                    onPressed: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => CreateCompany(employee),
                                      ),
                                    ),
                                    style: textButtonStyleRegister,
                                  ),
                                ),
                              ),
                              SizedBox(
                                height: 100,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                  child: TextButton(
                                    child: Text("Join Company",
                                        style: TextStyle(
                                          fontFamily: font,
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        )),
                                    onPressed: () => Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => JoinCompany(employee),
                                        )),
                                    style: textButtonStyleRegister,
                                  ),
                                ),
                              ),
                            ],
                          )
                    : Column(
                        children: [
                          // sve sto treba biti ispod slike i imena kad si u firmi
                          Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
                            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                              Row(children: [
                                Icon(
                                  Icons.house_outlined,
                                  color: Colors.white,
                                  size: 50,
                                ),
                                SizedBox(width: 10),
                                Text(company.name, style: inputTextStyle.copyWith(fontSize: detailsSize)),
                              ]),
                              Row(
                                children: [
                                  Icon(
                                    Icons.home_repair_service_outlined,
                                    color: Colors.white,
                                    size: 50,
                                  ),
                                  SizedBox(width: 10),
                                  Text(
                                    employee.position == '' ? 'Position' : employee.position,
                                    style: inputTextStyle.copyWith(fontSize: detailsSize),
                                  )
                                ],
                              ),
                            ]),
                            // RichText(
                            //     text: TextSpan(children: [
                            //   WidgetSpan(
                            //       child: Icon(
                            //     Icons.home_repair_service_outlined,
                            //     color: Colors.white,
                            //   )),
                            //   TextSpan(
                            //       text: 'pos' /*employee.position*/,
                            //       style: inputTextStyle)
                            // ])),
                            SizedBox(
                              width: 35,
                            ),
                            TextButton(
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
                                                      style: inputTextStyle.copyWith(fontSize: detailsSize),
                                                    )),
                                        ));
                              },
                            ),
                          ]),
                          SizedBox(height: 50),
                          Container(
                              child: Text(
                            'Surveys',
                            style: inputTextStyle.copyWith(fontSize: detailsSize),
                          )),
                          SizedBox(height: 30),
                          employee.surveys.length > 0
                              ? surveys
                              : Center(
                                  child: Text(
                                    'There are no new surveys',
                                    style: inputTextStyle.copyWith(fontSize: detailsSize),
                                  ),
                                )
                        ],
                      ),
              ],
            ),
          );
  }

  Widget getSurveys(Employee employee) {
    setState(() => numOfSurveys = employee.surveys.length);
    return FutureBuilder(
      future: employee.handleSurveys(),
      builder: (context, snapshot) => snapshot.connectionState != ConnectionState.done
          ? loader
          : Container(
              height: 80,
              child: ListView.separated(
                // padding: EdgeInsets.only(left: 20, right: 20),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (context, index) => activeSurveys(employee.surveys[index], employee),
                separatorBuilder: (context, index) => SizedBox(width: 20),
                itemCount: employee.surveys.length,
              ),
            ),
    );
  }

  Widget activeSurveys(Survey survey, Employee employee) {
    DateFormat _formatted = DateFormat('dd-MM-yyyy');
    return Container(
      // padding: ,
      //height: ,
      // width: 200,
      decoration: BoxDecoration(
          color: Colors.blue[50],
          borderRadius: borderRadius,
          gradient: LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.indigo, Colors.blue])),

      child: (TextButton.icon(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                //fullscreenDialog: true,
                builder: (context) => SurveyUIFill(survey, employee),
              ));
        },
        icon: Icon(
          (Icons.bar_chart_rounded),
          color: Colors.greenAccent,
          size: 50,
        ),
        label: Text(
          survey.name + "\n" + "until: " + _formatted.format(survey.to),
          style: TextStyle(fontFamily: font, fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
          textAlign: TextAlign.center,
        ),
      )),
    );
  }
}
