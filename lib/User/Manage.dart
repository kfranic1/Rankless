import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
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
  List<DropdownMenuItem<String>> positions = [];
  List<DropdownMenuItem<String>> tags = [];
  List<int> _selectedTags = [];
  bool loading = false;
  var _searchview = new TextEditingController();
  List<Employee> _filterListEmp = [];
  List<String> _filterListPos = [];
  List<String> _filterListTag = [];
  bool _firstSearch = true;
  String _query = "";
  int filterListCnt = 0;
  int itemCnt = 0;

  _ManageState() {
    //Register a closure to be called when the object changes.
    _searchview.addListener(() {
      if (_searchview.text.isEmpty) {
        //Notify the framework that the internal state of this object has changed.
        setState(() {
          _firstSearch = true;
          _query = "";
        });
      } else {
        setState(() {
          _firstSearch = false;
          _query = _searchview.text;
        });
      }
    });
  }

  @override
  void initState() {
    _filterListEmp = widget.company.employees;
    positions = widget.company.positions.map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList();

    tags = widget.company.tags.map<DropdownMenuItem<String>>((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList();

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
          isSelected[1] || isSelected[2] ? FloatingActionButton(child: Icon(Icons.add), onPressed: () => addPosOrTag()) : Container(),
      body: Container(
        padding: EdgeInsets.all(10),
        height: double.infinity,
        width: double.infinity,
        decoration: backgroundDecoration,
        child: loading
            ? loader
            : SingleChildScrollView(
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
                                                      style: TextStyle(
                                                          color: Colors.white, fontFamily: font, fontSize: 15, fontWeight: FontWeight.bold)),
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
                    _createSearchView(),
                    _firstSearch ? _createListView(selectedIdx(true)) : _performSearch(selectedIdx(false)),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _createSearchView() {
    return new Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
          border: Border.all(
            width: 1.0,
            color: primaryBlue,
          ),
          borderRadius: borderRadius),
      child: new TextField(
        controller: _searchview,
        style: inputTextStyle,
        decoration: InputDecoration(
          hintText: "Search",
          border: InputBorder.none,
          hintStyle: inputTextStyle.copyWith(color: Colors.white.withOpacity(0.5)),
        ),
        textAlign: TextAlign.left,
      ),
    );
  }

  Widget _createListView(int i) {
    return Visibility(
      visible: isSelected[i],
      child: Container(
        child: ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              if (i == 0) {
                return buildEmpTile(index, true);
              }
              if (i == 1) {
                return buildPosTile(index, true);
              }
              return buildTagTile(index, true);
            },
            separatorBuilder: (context, index) => i == 1 || i == 2
                ? SizedBox(
                    child: Divider(
                      color: Colors.white,
                    ),
                    height: 15,
                  )
                : SizedBox(
                    height: 20,
                  ),
            itemCount: itemCnt),
      ),
    );
  }

  Widget _performSearch(int i) {
    if (i == 0) {
      _filterListEmp = [];
      for (int i = 0; i < widget.company.employees.length; i++) {
        Employee emp = widget.company.employees[i];
        String name = emp.name + ' ' + emp.surname;

        if (name.toLowerCase().contains(_query.toLowerCase())) {
          _filterListEmp.add(emp);
        }
      }
    }
    if (i == 1) {
      _filterListPos = [];
      for (int i = 0; i < widget.company.positions.length; i++) {
        String inputPosition = widget.company.positions[i];

        if (inputPosition.toLowerCase().contains(_query.toLowerCase())) {
          _filterListPos.add(inputPosition);
        }
      }
    }
    if (i == 2) {
      _filterListTag = [];
      for (int i = 0; i < widget.company.tags.length; i++) {
        String inputTag = widget.company.tags[i];

        if (inputTag.toLowerCase().contains(_query.toLowerCase())) {
          _filterListTag.add(inputTag);
        }
      }
    }
    return _createFilteredListView(i);
  }

  Widget _createFilteredListView(int i) {
    return Visibility(
      visible: isSelected[i],
      child: Container(
        child: ListView.separated(
            shrinkWrap: true,
            itemBuilder: (context, index) {
              if (i == 0) {
                return buildEmpTile(index, false);
              }
              if (i == 1) {
                return buildPosTile(index, false);
              }
              return buildTagTile(index, false);
            },
            separatorBuilder: (context, index) => i == 1 || i == 2
                ? SizedBox(
                    child: Divider(
                      color: Colors.white,
                    ),
                    height: 15,
                  )
                : SizedBox(
                    height: 20,
                  ),
            itemCount: filterListCnt),
      ),
    );
  }

  int selectedIdx(bool flag) {
    if (isSelected[0]) {
      flag ? itemCnt = widget.company.employees.length : filterListCnt = _filterListEmp.length;
      return 0;
    }

    if (isSelected[1]) {
      flag ? itemCnt = widget.company.positions.length : filterListCnt = _filterListPos.length;
      return 1;
    }
    flag ? itemCnt = widget.company.tags.length : filterListCnt = _filterListTag.length;

    return 2;
  }

  Widget buildEmpTile(int index, bool flag) {
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
        decoration: secondaryGradientDecoration,
        child: (ListTile(
          title: Text(
            flag
                ? widget.company.employees[index].name + ' ' + widget.company.employees[index].surname
                : _filterListEmp[index].name + ' ' + _filterListEmp[index].surname,
            style: TextStyle(color: Colors.white, fontFamily: font, fontSize: 20),
            textAlign: TextAlign.left,
          ),
          trailing: Text(
            flag
                ? widget.company.employees[index].position == ""
                    ? 'No position'
                    : widget.company.employees[index].position
                : _filterListEmp[index].position == ""
                    ? 'No position'
                    : _filterListEmp[index].position,
            style: inputTextStyle.copyWith(fontSize: 16),
          ),
          onTap: () {
            showDialog(
                context: context,
                builder: (context) => Theme(
                      data: ThemeData(
                        accentColor: Colors.black,
                        focusColor: Colors.black,
                        buttonColor: Colors.white,
                        textSelectionTheme: TextSelectionThemeData(
                          cursorColor: Colors.white,
                          selectionColor: Colors.white,
                          selectionHandleColor: Colors.white,
                        ),
                        hintColor: Colors.white,
                        fontFamily: font,
                      ),
                      child: Dialog(
                        shape: dialogShape,
                        backgroundColor: primaryBlue,
                        child: SingleChildScrollView(
                          child: Column(children: [
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.all(30),
                              child: Text(
                                "Position",
                                style: inputTextStyle.copyWith(fontSize: 22),
                              ),
                            ),
                            SearchChoices.single(
                              menuBackgroundColor: Colors.white,
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.white,
                              ),
                              clearIcon: Icon(
                                Icons.clear,
                                color: Colors.white,
                              ),
                              iconSize: 30,
                              style: inputTextStyle,
                              items: positions,
                              value: widget.company.employees[index].position,
                              hint: widget.company.employees[index].position == ""
                                  ? Text(
                                      'No position',
                                      style: inputTextStyle,
                                    )
                                  : widget.company.employees[index].position,
                              searchHint: "Select one",
                              onChanged: (value) async {
                                setState(() {
                                  loading = true;
                                });
                                await widget.company.addPositionOrTags(widget.company.employees[index], position: value);
                                setState(() {
                                  loading = false;
                                });
                              },
                              onClear: () async {
                                setState(() {
                                  loading = true;
                                });
                                await widget.company.addPositionOrTags(widget.company.employees[index], position: "");
                                setState(() {
                                  loading = false;
                                });
                                Navigator.of(context).pop();
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
                                            Icons.check_box_outline_blank,
                                            color: Colors.grey,
                                          ),
                                    SizedBox(width: 7),
                                    Expanded(
                                      child: Text(
                                        item.value,
                                        style: TextStyle(fontFamily: font, fontSize: 18),
                                      ),
                                    ),
                                  ])),
                                ]);
                              },
                              isExpanded: true,
                            ),
                            Container(
                              alignment: Alignment.centerLeft,
                              padding: EdgeInsets.all(30),
                              child: Text(
                                "Tags",
                                style: inputTextStyle.copyWith(fontSize: 22),
                              ),
                            ),
                            SearchChoices.multiple(
                              doneButton: Container(),
                              selectedItems: selectedTags(widget.company.employees[index]),
                              menuBackgroundColor: Colors.white,
                              icon: Icon(
                                Icons.arrow_drop_down,
                                color: Colors.white,
                              ),
                              displayClearIcon: false,
                              iconSize: 30,
                              style: inputTextStyle,
                              items: tags,
                              hint: 'Add new tag',
                              searchHint: "Select one",
                              onChanged: (value) async {
                                setState(() {
                                  loading = true;
                                });
                                List<String> list = [];
                                value.forEach((element) => list.add(widget.company.tags[element]));
                                await widget.company.addPositionOrTags(widget.company.employees[index], addTags: list);
                                setState(() {
                                  loading = false;
                                });
                              },
                              // onClear: () async {
                              //   setState(() {
                              //     loading = true;
                              //   });
                              //   await widget.company.addPositionOrTags(widget.company.employees[index], removeTags: true);
                              //   setState(() {
                              //     loading = false;
                              //   });
                              //   Navigator.of(context).pop();
                              // },
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
                                            Icons.check_box_outline_blank,
                                            color: Colors.grey,
                                          ),
                                    SizedBox(width: 7),
                                    Expanded(
                                      child: Text(
                                        item.value,
                                        style: TextStyle(fontFamily: font, fontSize: 18),
                                      ),
                                    ),
                                  ])),
                                ]);
                              },
                              isExpanded: true,
                            ),
                          ]),
                        ),
                      ),
                    ));
          },
        )),
      ),
    );
  }

  Widget buildPosTile(int index, bool flag) {
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
          widget.company.positions.removeAt(index);
        });
      },
      confirmDismiss: (DismissDirection direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            if (hasPosition(widget.company.positions[index], widget.company.employees)) {
              return AlertDialog(
                content: Text('You can not remove position because there are still employees with this position'),
              );
            }
            return AlertDialog(
              title: const Text(
                "Confirm",
                style: TextStyle(fontFamily: font, fontWeight: FontWeight.bold),
              ),
              content: const Text(
                "Are you sure you want to remove this position from your company?",
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
        // decoration: BoxDecoration(
        //     borderRadius: borderRadius,
        //     gradient: LinearGradient(begin: Alignment.centerLeft, end: Alignment.centerRight, colors: [Colors.indigo, Colors.transparent])),
        padding: EdgeInsets.all(20),
        child: Text(
          flag ? widget.company.positions[index] : _filterListPos[index],
          style: inputTextStyle,
          textAlign: TextAlign.center,
        ),
        alignment: Alignment.center,
      ),
    );
  }

  Widget buildTagTile(int index, bool flag) {
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
          widget.company.positions.removeAt(index);
        });
      },
      confirmDismiss: (DismissDirection direction) async {
        return await showDialog(
          context: context,
          builder: (BuildContext context) {
            if (hasTag(widget.company.tags[index], widget.company.employees)) {
              return AlertDialog(
                content: Text('You can not remove position because there are still employees with this position'),
              );
            }
            return AlertDialog(
              title: const Text(
                "Confirm",
                style: TextStyle(fontFamily: font, fontWeight: FontWeight.bold),
              ),
              content: const Text(
                "Are you sure you want to remove this position from your company?",
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
        padding: EdgeInsets.all(20),
        child: Text(
          flag ? widget.company.tags[index] : _filterListTag[index],
          style: inputTextStyle,
          textAlign: TextAlign.center,
        ),
        alignment: Alignment.center,
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

  List<int> selectedTags(Employee e) {
    List<int> list = [];
    e.tags.forEach((element) {
      for (int i = 0; i < widget.company.tags.length; i++) {
        if (element == widget.company.tags[i]) {
          list.add(i);
        }
      }
    });
    return list;
  }

  bool hasPosition(String position, List<Employee> listEmp) {
    bool result = false;
    listEmp.forEach((element) {
      if (element.position == position) result = true;
    });
    return result;
  }

  bool hasTag(String tag, List<Employee> listEmp) {
    bool result = false;
    listEmp.forEach((element) {
      element.tags.forEach((element) {
        if (element == tag) result = true;
      });
    });
    return result;
  }
}
