import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:provider/provider.dart';
import 'package:rankless/Survey/SurveyUIFill.dart';
import 'package:rankless/shared/Interface.dart';
import 'Company.dart';
import 'CreateCompany.dart';
import 'package:rankless/Survey/Survey.dart';
import 'JoinCompany.dart';

import 'Employee.dart';

double detailsSize = 22.0;

class EmployeeHomeScreen extends StatefulWidget {
  @override
  _EmployeeHomeScreenState createState() => _EmployeeHomeScreenState();
}

class _EmployeeHomeScreenState extends State<EmployeeHomeScreen> {
  bool isCancelDisabled = false;
  bool imageLoading = false;
  @override
  void initState() {
    final employee = Provider.of<Employee>(context, listen: false);
    if (employee.request != null &&
        (employee.request.contains('accepted') ||
            employee.request.contains('denied')))
      SchedulerBinding.instance.addPostFrameCallback(
        (_) => showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text(
                    'You were ' +
                        ((employee.request.contains('accepted')
                                ? 'accepted to '
                                : 'denied from ') +
                            employee.request
                                .substring(employee.request.indexOf('%') + 1)),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () async {
                        Navigator.of(context).pop();
                        await employee.updateEmployee(newRequest: '');
                      },
                      child: Text('OK'),
                    ),
                  ],
                ),
            useRootNavigator: false),
      );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Company company = Provider.of<Company>(context);
    final employee = Provider.of<Employee>(context);
    employee.surveys.forEach((element) {
      print(element.uid);
    });
    return Container(
        decoration: backgroundDecoration,
        padding: EdgeInsets.all(20),
        child: ListView(children: [
          Row(
            children: [
              IconButton(
                iconSize: 100,
                icon: imageLoading
                    ? Center(child: loader)
                    : Container(
                        alignment: Alignment.topLeft,
                        // padding: EdgeInsets.all(10),

                        child: FutureBuilder(
                            future: employee.getImage(),
                            builder: (context, snapshot) {
                              return CircleAvatar(
                                radius: 50, //should be half of icon size
                                backgroundImage: employee.image == null
                                    ? null
                                    : employee.image,
                                child: employee.image == null
                                    ? Text(
                                        (employee.name[0] + employee.surname[0])
                                            .toUpperCase(),
                                        style: TextStyle(
                                            fontSize: 25,
                                            fontFamily: font,
                                            letterSpacing: 2.0),
                                      )
                                    : null,
                              );
                            }),
                      ),
                onPressed: () async {
                  setState(() => imageLoading = true);
                  await employee.getImage();
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
                  maxLines: 4,
                  overflow:
                      TextOverflow.ellipsis, // ako bude jos dulje, bit ce ...
                ),
              ),
              // ),
            ],
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,     // htjela sam umjesto SizedBoxa, ali ne radi
          ),
          SizedBox(height: 20),
          employee.companyUid == null
              ? employee.request != ''
                  ? Column(
                      children: [
                        Text(
                            "You sent request to " +
                                employee.request.substring(
                                    employee.request.indexOf('%') + 1),
                            style: inputTextStyle),
                        SizedBox(height: 20),
                        isCancelDisabled
                            ? Container()
                            : TextButton(
                                onPressed: () async {
                                  setState(() => isCancelDisabled = true);
                                  await employee.cancelRequestToCompany();
                                  setState(() => isCancelDisabled = false);
                                },
                                child: Text("Cancel request",
                                    style: inputTextStyle),
                                style: textButtonStyleRegister,
                              ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: TextButton(
                              child: Text(
                                "Create Company",
                                style: TextStyle(
                                    fontFamily: font,
                                    fontSize: 15,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white),
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
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            child: TextButton(
                              child: Text("Join Company",
                                  style: TextStyle(
                                      fontFamily: font,
                                      fontSize: 15,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white)),
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
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(children: [
                                  Icon(
                                    Icons.house_outlined,
                                    color: Colors.white,
                                    size: 50,
                                  ),
                                  SizedBox(width: 10),
                                  Text(company.name,
                                      style: inputTextStyle.copyWith(
                                          fontSize: detailsSize)),
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
                                      employee.position == ''
                                          ? 'Position'
                                          : employee.position,
                                      style: inputTextStyle.copyWith(
                                          fontSize: detailsSize),
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
                              style: inputTextStyle.copyWith(
                                  fontSize: detailsSize),
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
                                                    itemBuilder:
                                                        (context, index) {
                                                      return Text(
                                                        employee.tags[index],
                                                        style: inputTextStyle
                                                            .copyWith(
                                                                fontSize:
                                                                    detailsSize),
                                                      );
                                                    },
                                                    itemCount:
                                                        employee.tags.length,
                                                    separatorBuilder: (context,
                                                            index) =>
                                                        SizedBox(height: 20),
                                                  )
                                                : Text(
                                                    'You don\'t have any tags',
                                                    style:
                                                        inputTextStyle.copyWith(
                                                            fontSize:
                                                                detailsSize),
                                                  )),
                                      ));
                            },
                          ),
                          // employee.tags.length != 0
                          //     ? Expanded(
                          //         child: ListView.separated(
                          //           shrinkWrap: true,
                          //           itemBuilder: (context, index) {
                          //             return Text(
                          //               employee.tags[index],
                          //               style: inputTextStyle.copyWith(
                          //                   fontSize: detailsSize),
                          //             );
                          //           },
                          //           itemCount: employee.tags.length,
                          //           separatorBuilder: (context, index) {
                          //             return SizedBox(
                          //               height: 5,
                          //               width: 5,
                          //             );
                          //           },
                          //         ),
                          //       )
                          //     : Text('You have no tags', style: inputTextStyle),
                        ]),
                    SizedBox(height: 20),
                    employee.surveys.length > 0
                        ? FutureBuilder(
                            future: employee.handleSurveys(),
                            builder: (context, snapshot) => snapshot
                                        .connectionState ==
                                    ConnectionState.active
                                ? Center(
                                    child: CircularProgressIndicator(),
                                  )
                                : Center(
                                    child: TextButton(
                                      onPressed: () async {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => SurveyUIFill(
                                                employee.surveys[0], employee),
                                          ),
                                        );
                                      },
                                      child: Text(
                                          'You have ' +
                                              employee.surveys
                                                  .where((element) {
                                                    print(element.name);
                                                    return element.status ==
                                                        STATUS.Active;
                                                  })
                                                  .length
                                                  .toString() +
                                              ' active and ' +
                                              employee.surveys
                                                  .where((element) =>
                                                      element.status ==
                                                      STATUS.Upcoming)
                                                  .length
                                                  .toString() +
                                              ' upcoming surveys',
                                          style: inputTextStyle),
                                    ),
                                  ),
                          )
                        : Center(
                            child: Text(
                              'There are no new surveys',
                              style: inputTextStyle.copyWith(
                                  fontSize: detailsSize),
                            ),
                          )
                  ],
                ),
        ]));
  }
}
