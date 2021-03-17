import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rankless/Survey/Survey.dart';
import 'package:rankless/Survey/SurveyUI.dart';
import 'package:rankless/User/Employee.dart';

import 'Company.dart';

class CompanyHomeScreen extends StatefulWidget {
  @override
  _CompanyHomeScreenState createState() => _CompanyHomeScreenState();
}

class _CompanyHomeScreenState extends State<CompanyHomeScreen> {
  ListView requests;
  bool handling = false;
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
                ? FloatingActionButton(
                    child: Icon(Icons.add),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => SurveyUI(
                          new Survey(name: 'Survey', company: company),
                        ),
                      ),
                    ),
                  )
                : Container(),
            body: ListView(
              shrinkWrap: true,
              children: [
                Center(
                  child: Text(
                    "Company is " + company.name,
                  ),
                ),
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
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Container(
                                                        color: Colors.green,
                                                        child: TextButton.icon(
                                                          icon:
                                                              Icon(Icons.check),
                                                          label: Text('Allow'),
                                                          onPressed: () async {
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
                                                          const EdgeInsets.all(
                                                              8.0),
                                                      child: Container(
                                                        color: Colors.red,
                                                        child: TextButton.icon(
                                                          icon: Icon(
                                                              Icons.cancel),
                                                          label: Text('Deny'),
                                                          onPressed: () async {
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
                TextButton(
                    onPressed: () async {
                      Survey sur = await Survey(uid: 'fRKQtId76sevJWKL7rIJ')
                          .getSurvey(true);
                      print(sur.getResults());
                      //company.addPositionOrTags(me, newTags: ['tim1']);
                    },
                    child: Text('add stuff')),
              ],
            ),
          );
  }
}
