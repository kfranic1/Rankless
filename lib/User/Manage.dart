import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rankless/Survey/Results.dart';
import 'package:rankless/Survey/Survey.dart';
import 'package:rankless/Survey/SurveyUI.dart';
import 'package:rankless/User/Employee.dart';
import 'package:rankless/shared/Interface.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:search_choices/search_choices.dart';
import 'Company.dart';

class Manage extends StatefulWidget {
  final Company company;
  Manage(this.company);
  @override
  _ManageState createState() => _ManageState();
}

class _ManageState extends State<Manage> {
  List<DropdownMenuItem<String>> searchEmployees = [];
  String foundEmployee;
  bool handling = false;
  List<bool> isSelected = [true, false, false];

  @override
  void initState() {
    widget.company.getEmployees().then((value) {
      widget.company.employees.forEach((element) {
        String temp = element.name + " " + element.surname;
        this.searchEmployees.add(
              DropdownMenuItem(
                child: Text(temp),
                value: element.name + " " + element.surname,
              ),
            );
        setState(() {
          searchEmployees = searchEmployees;
        });
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Employee me = Provider.of<Employee>(context);
    return Scaffold(
      floatingActionButton:
          isSelected[1] == true || isSelected[2] == true ? FloatingActionButton(child: Icon(Icons.add), onPressed: () => addPosOrTag()) : Container(),
      body: Container(
        padding: EdgeInsets.all(10),
        height: double.infinity,
        width: double.infinity,
        decoration: backgroundDecoration,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                margin: EdgeInsets.only(top: 30),
                child: Text(
                  "Manage",
                  style: titleNameStyle,
                ),
              ),
              Visibility(
                visible: (me.admin && widget.company.requests.length != 0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: handling
                        ? Center(child: CircularProgressIndicator())
                        : Stack(
                            children: widget.company.requests
                                .map(
                                  (e) {
                                    String nameTemp = e.substring(e.indexOf('%') + 1, e.lastIndexOf('%'));
                                    String surnameTemp = e.substring(e.lastIndexOf('%') + 1);
                                    return Dismissible(
                                      dragStartBehavior: DragStartBehavior.down,
                                      resizeDuration: Duration(microseconds: 100),
                                      key: UniqueKey(),
                                      onDismissed: (direction) => {
                                        if (direction == DismissDirection.endToStart)
                                          setState(() {
                                            widget.company.requests.add(widget.company.requests[0]);
                                            widget.company.requests.removeAt(0);
                                          })
                                        else
                                          {
                                            setState(() {
                                              widget.company.requests.insert(0, widget.company.requests.last);
                                              widget.company.requests.removeLast();
                                            })
                                          }
                                      },
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Colors.blue[50],
                                            borderRadius: borderRadius,
                                            gradient: LinearGradient(
                                                begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.indigo, Colors.blue])),
                                        margin: EdgeInsets.only(top: 40),
                                        child: Column(
                                          children: [
                                            Text('Requested to join your company',
                                                style: TextStyle(color: Colors.white, fontFamily: font, fontSize: 15, fontWeight: FontWeight.bold)),
                                            Row(
                                              children: [
                                                Expanded(
                                                  flex: 3,
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 30.0),
                                                    child: Text(
                                                      nameTemp + ' ' + surnameTemp,
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontFamily: font,
                                                        fontSize: 18,
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.only(left: 3.0),
                                                    child: IconButton(
                                                      color: Colors.green,
                                                      iconSize: 35,
                                                      icon: Icon(Icons.check),
                                                      onPressed: () async {
                                                        setState(() => handling = true);
                                                        await widget.company.handleRequest(true);
                                                        setState(() => handling = false);
                                                      },
                                                    ),
                                                  ),
                                                ),
                                                Expanded(
                                                  child: Padding(
                                                    padding: const EdgeInsets.all(8.0),
                                                    child: IconButton(
                                                      color: Colors.redAccent[700],
                                                      iconSize: 35,
                                                      icon: Icon(Icons.cancel_outlined),
                                                      onPressed: () async {
                                                        setState(() {
                                                          handling = true;
                                                        });
                                                        widget.company.handleRequest(false);
                                                        setState(() => handling = false);
                                                      },
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
              Container(
                padding: EdgeInsets.only(top: 30),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    return ToggleButtons(
                      color: Colors.white,
                      textStyle: TextStyle(fontSize: 18, fontFamily: font),
                      renderBorder: false,
                      constraints: BoxConstraints.expand(width: constraints.maxWidth / 3, height: 50),
                      borderRadius: borderRadius,
                      children: <Widget>[
                        Text("Employees"),
                        Text("Positions"),
                        Text("Tags"),
                      ],
                      onPressed: (int index) {
                        setState(() {
                          for (int buttonIndex = 0; buttonIndex < isSelected.length; buttonIndex++) {
                            if (buttonIndex == index) {
                              isSelected[buttonIndex] = true;
                            } else {
                              isSelected[buttonIndex] = false;
                            }
                          }
                        });
                      },
                      isSelected: isSelected,
                    );
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.only(top: 20),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(border: Border.all(color: Colors.white), borderRadius: BorderRadius.all(Radius.circular(30))),
                child: SearchChoices.single(
                  items: searchEmployees,
                  value: foundEmployee,
                  style: TextStyle(color: Colors.white, fontFamily: font, fontSize: 18),
                  hint: Text(
                    "Search employees",
                    style: TextStyle(fontFamily: font, color: Colors.white.withOpacity(0.5), fontSize: 18),
                    textAlign: TextAlign.left,
                  ),
                  underline: Container(),
                  searchHint: "Search employees",
                  onChanged: (value) {
                    setState(() {
                      foundEmployee = value;
                    });
                  },
                  icon: Container(),
                  isExpanded: true,
                  selectedValueWidgetFn: (item) {
                    return Container(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        item,
                        textAlign: TextAlign.start,
                      ),
                    );
                  },
                ),
              ),
              Visibility(
                visible: isSelected[0],
                child: Container(
                  child: ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return buildEmpTile(index);
                      },
                      separatorBuilder: (context, index) => SizedBox(
                            height: 20,
                          ),
                      itemCount: widget.company.employees.length),
                ),
              ),
              Visibility(
                visible: isSelected[1],
                child: Container(
                  child: ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return buildPosTile(index);
                      },
                      separatorBuilder: (context, index) => SizedBox(
                            height: 20,
                          ),
                      itemCount: widget.company.positions.length),
                ),
              ),
              Visibility(
                visible: isSelected[2],
                child: Container(
                  child: ListView.separated(
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return buildTagTile(index);
                      },
                      separatorBuilder: (context, index) => SizedBox(
                            height: 20,
                          ),
                      itemCount: widget.company.tags.length),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildEmpTile(int index) {
    return Dismissible(
      direction: DismissDirection.endToStart,
      background: Container(
        alignment: Alignment.centerRight,
        padding: EdgeInsets.only(right: 20),
        child: Icon(Icons.delete),
        color: Colors.red,
      ),
      key: UniqueKey(),
      onDismissed: (direction) {
        setState(() {
          widget.company.employees.removeAt(index);
        });
      },
      confirmDismiss: (DismissDirection direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: const Text(
                "Confirm",
                style: TextStyle(fontFamily: font, fontWeight: FontWeight.bold),
              ),
              content: const Text(
                "Are you sure you remove this employee from your company?",
                style: TextStyle(fontFamily: font),
              ),
              actions: <Widget>[
                TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text("DELETE", style: TextStyle(fontFamily: font))),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(false),
                  child: const Text("CANCEL", style: TextStyle(fontFamily: font)),
                ),
              ],
            );
          },
        );
      },
      child: Container(
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.only(bottom: 10),
        decoration: popOutDecoration,
        child: (ListTile(
          title: Text(
            widget.company.employees[index].name + ' ' + widget.company.employees[index].surname,
            style: TextStyle(color: Colors.white, fontFamily: font, fontSize: 20),
            textAlign: TextAlign.left,
          ),
          onTap: () {
            showDialog(
                context: context,
                builder: (context) => Dialog(
                      child: Column(children: [
                        Container(
                            padding: EdgeInsets.all(25),
                            //height: 300,
                            color: Colors.blue,
                            child: widget.company.employees[index].tags.isNotEmpty
                                ? ListView.separated(
                                    itemBuilder: (context, ind) {
                                      return Text(
                                        widget.company.employees[index].tags[ind],
                                        style: inputTextStyle.copyWith(fontSize: 22),
                                      );
                                    },
                                    itemCount: widget.company.employees[index].tags.length,
                                    separatorBuilder: (context, index) => SizedBox(height: 20),
                                  )
                                : Text(
                                    'You don\'t have any tags',
                                    style: inputTextStyle.copyWith(fontSize: 22),
                                  )),
                      ]),
                    ));
          },
        )),
      ),
    );
  }

  Widget buildPosTile(int index) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: popOutDecoration,
      child: Text(
        widget.company.positions[index],
        style: inputTextStyle,
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget buildTagTile(int index) {
    return Container(
      padding: EdgeInsets.all(20),
      decoration: popOutDecoration,
      child: Text(
        widget.company.tags[index],
        style: inputTextStyle,
        textAlign: TextAlign.center,
      ),
    );
  }

  void addPosOrTag() {
    isSelected[1] == true
        ? showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                backgroundColor: Colors.white.withOpacity(0.2),
                child: Container(
                  child: TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(),
                        hintText: 'Add position',
                        hintStyle: inputTextStyle.copyWith(color: Colors.black.withOpacity(0.6))),
                    onFieldSubmitted: (value) {
                      setState(() => widget.company.positions.add(value));
                    },
                  ),
                ),
              );
            })
        : showDialog(
            context: context,
            builder: (BuildContext context) {
              return Dialog(
                backgroundColor: Colors.white.withOpacity(0.2),
                child: Container(
                  child: TextFormField(
                    decoration: InputDecoration(
                        border: OutlineInputBorder(), hintText: 'Add tag', hintStyle: inputTextStyle.copyWith(color: Colors.black.withOpacity(0.6))),
                    onFieldSubmitted: (value) {
                      setState(() => widget.company.tags.add(value));
                    },
                  ),
                ),
              );
            });
  }
}
