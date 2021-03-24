import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rankless/Survey/Results.dart';
import 'package:rankless/Survey/Survey.dart';
import 'package:rankless/Survey/SurveyUI.dart';
import 'package:rankless/User/Employee.dart';
import 'package:rankless/shared/Interface.dart';
import 'package:image_picker/image_picker.dart';

import 'Company.dart';

class CompanyHomeScreen extends StatefulWidget {
  @override
  _CompanyHomeScreenState createState() => _CompanyHomeScreenState();
}

class _CompanyHomeScreenState extends State<CompanyHomeScreen> {
  ListView requests;
  bool handling = false;
  PickedFile coverImage;
  bool imageLoading = false;
  @override
  Widget build(BuildContext context) {
    final Company company = Provider.of<Company>(context);
    final Employee me = Provider.of<Employee>(context);
    return company == null
        ? Center(
            child: Text('You are not in any company'),
          )
        : Scaffold(
            floatingActionButton: me.admin
                ? Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    me.admin
                        ? Expanded(
                            flex: 2,
                            child: FloatingActionButton(
                                backgroundColor: Colors.blue.withOpacity(0.7),
                                child: Icon(
                                  Icons.group_add_rounded,
                                  color: Colors.white,
                                  size: 30,
                                ),
                                onPressed: () {
                                  company
                                      .addPositionOrTags(me, addTags: ['tim1']);
                                }),
                          )
                        : Container(),
                    SizedBox(
                      width: 210,
                    ),
                    Expanded(
                      child: FloatingActionButton(
                        backgroundColor: Colors.blue.withOpacity(0.7),
                        child: Icon(
                          Icons.post_add_rounded,
                          size: 30,
                          color: Colors.white,
                        ),
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => SurveyUI(
                              new Survey(name: 'Survey', company: company),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ])
                : Container(),
            body: Container(
              width: double.infinity,
              height: double.infinity,
              decoration: backgroundDecoration,
              child: ListView(
                shrinkWrap: true,
                children: [
                  IconButton(
                      iconSize: 100,
                      icon: imageLoading
                          ? Center(
                              child: loader,
                            )
                          : Row(
                              children: [
                                Container(
                                    alignment: Alignment.topLeft,
                                    padding: EdgeInsets.only(left: 30),
                                    child: CircleAvatar(
                                        //backgroundColor: Colors.white,
                                        radius:
                                            50, //should be half of icon size
                                        backgroundImage: company.image == null
                                            ? null
                                            : company.image,
                                        child: company.image == null
                                            ? Icon(
                                                Icons.camera_alt_outlined,
                                                size: 60,
                                                //color: Colors.black,
                                              )
                                            : null)),
                                SizedBox(
                                  width: 60,
                                ),
                                Text(
                                  company.name,
                                  style: titleNameStyle,
                                )
                              ],
                            ),
                      onPressed: () {}), //franić?
                  Visibility(
                    visible: (me.admin && company.requests.length != 0),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Align(
                        alignment: Alignment.topCenter,
                        child: handling
                            ? Center(child: CircularProgressIndicator())
                            : Stack(
                                children: company.requests
                                    .map(
                                      (e) {
                                        String nameTemp = e.substring(
                                            e.indexOf('%') + 1,
                                            e.lastIndexOf('%'));
                                        String surnameTemp =
                                            e.substring(e.lastIndexOf('%') + 1);
                                        return Dismissible(
                                          dragStartBehavior:
                                              DragStartBehavior.down,
                                          resizeDuration:
                                              Duration(microseconds: 100),
                                          key: UniqueKey(),
                                          onDismissed: (direction) => {
                                            if (direction ==
                                                DismissDirection.endToStart)
                                              setState(() {
                                                company.requests
                                                    .add(company.requests[0]);
                                                company.requests.removeAt(0);
                                              })
                                            else
                                              {
                                                setState(() {
                                                  company.requests.insert(
                                                      0, company.requests.last);
                                                  company.requests.removeLast();
                                                })
                                              }
                                          },
                                          child: Card(
                                            child: Column(
                                              children: [
                                                Text(nameTemp +
                                                    ' ' +
                                                    surnameTemp +
                                                    ' has requested to join your company'),
                                                Row(
                                                  children: [
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Container(
                                                          color: Colors.green,
                                                          child:
                                                              TextButton.icon(
                                                            icon: Icon(
                                                                Icons.check),
                                                            label:
                                                                Text('Allow'),
                                                            onPressed:
                                                                () async {
                                                              setState(() =>
                                                                  handling =
                                                                      true);
                                                              company
                                                                  .handleRequest(
                                                                      true);
                                                              setState(() =>
                                                                  handling =
                                                                      false);
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                    Expanded(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(8.0),
                                                        child: Container(
                                                          color: Colors.red,
                                                          child:
                                                              TextButton.icon(
                                                            icon: Icon(
                                                                Icons.cancel),
                                                            label: Text('Deny'),
                                                            onPressed:
                                                                () async {
                                                              setState(() {
                                                                handling = true;
                                                              });
                                                              company
                                                                  .handleRequest(
                                                                      false);
                                                              setState(() =>
                                                                  handling =
                                                                      false);
                                                            },
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        );
                                      },
                                    )
                                    .toList()
                                    .reversed
                                    .toList(),
                              ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                          child: Container(
                        child: ListTile(
                          leading: Icon(
                            Icons.list,
                            color: Colors.white,
                            size: 50,
                          ),
                          title: Text(
                            company.industry,
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: font,
                                fontSize: 22),
                          ),
                        ),
                        padding: EdgeInsets.only(left: 15),
                      )),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.only(left: 70),
                          child: ListTile(
                            leading: Icon(
                              Icons.format_list_numbered_rounded,
                              color: Colors.white,
                              size: 50,
                            ),
                            title: Text(
                              '#',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontFamily: font,
                                  fontSize: 22),
                            ), //ovdje ide pozicija na rankingu
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: IconButton(
                            icon: Icon(
                              Icons.info_outline_rounded,
                              color: Colors.white,
                              size: 50,
                            ),
                            onPressed: () {}),
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      Expanded(
                        child: IconButton(
                          icon: Icon(
                            Icons.insert_chart_outlined_rounded,
                            color: Colors.white,
                            size: 50,
                          ),
                          onPressed: () {},
                        ),
                      ),
                      SizedBox(
                        width: 50,
                      ),
                      Expanded(
                        child: IconButton(
                          icon: Icon(
                            Icons.chat_bubble_outline_rounded,
                            color: Colors.white,
                            size: 50,
                          ),
                          onPressed: () {},
                        ),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 40,
                  ),
                  // Container(
                  //     margin: EdgeInsets.only(left: 20, right: 20),
                  //     decoration: BoxDecoration(
                  //         border: Border.all(color: Colors.white, width: 2),
                  //         borderRadius: borderRadius),
                  //     child: TextButton(
                  //       onPressed: () {
                  //         company.addPositionOrTags(me, newTags: ['tim1']);
                  //       },
                  //       child: Text('Manage',
                  //           style: TextStyle(
                  //               fontFamily: font,
                  //               color: Colors.white,
                  //               fontSize: 22)),
                  //     )),
                  TextButton(
                      onPressed: () {
                        //print(company.surveysFull.length);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              //fullscreenDialog: true,
                              builder: (context) =>
                                  Results(Survey(uid: 'fRKQtId76sevJWKL7rIJ'))),
                        );
                      },
                      child: Text('Press me')),
                  Container(
                    height: 80,
                    child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        shrinkWrap: true,
                        itemBuilder: (context, index) {
                          return filledSurveys(company.surveys[index]);
                        },
                        separatorBuilder: (context, index) => SizedBox(
                              width: 20,
                            ),
                        itemCount: company.surveys.length),
                  )
                ],
              ),
            ),
          );
  }

  Widget filledSurveys(Survey survey) {
    return Container(
      decoration: BoxDecoration(color: Colors.blue),
      child: (TextButton(
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                //fullscreenDialog: true,
                builder: (context) => Results(survey),
              ));
        },
        child: Text(survey.name +
            "\n" +
            survey.from.toString() +
            " - " +
            survey.to.toString()),
      )),
    );
  }
}
