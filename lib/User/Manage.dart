import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rankless/User/Employee.dart';
import 'package:rankless/shared/Interface.dart';
import 'package:flutter/widgets.dart';
import 'package:search_choices/search_choices.dart';
import 'Company.dart';

class Manage extends StatefulWidget {
  final Company company;
  Manage(this.company);
  @override
  _ManageState createState() => _ManageState();
}

class _ManageState extends State<Manage> {
  List<bool> isSelected = [true, false, false];
  List<DropdownMenuItem<String>> positions = [];
  List<DropdownMenuItem<String>> tags = [];
  bool loading = false;
  var _searchview = new TextEditingController();
  String _query = "";

  String myUid;
  Future _future;

  @override
  void initState() {
    super.initState();
    final Employee me = Provider.of<Employee>(context, listen: false);
    myUid = me.uid;

    _searchview.addListener(() {
      setState(() => _query = _searchview.text);
    });
    _future = widget.company.getEmployees();
  }

  @override
  void dispose() {
    _searchview.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    //print(widget.company.employees[0].name);
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

    return Scaffold(
      floatingActionButton: isSelected[1] || isSelected[2]
          ? FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => addPosOrTag(),
            )
          : Container(),
      body: GestureDetector(
        onTap: () => loseFocus(),
        child: Container(
            padding: EdgeInsets.all(10),
            height: double.infinity,
            width: double.infinity,
            decoration: backgroundDecoration,
            child: FutureBuilder(
                future: _future,
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) return loader;
                  return Column(
                    children: [
                      Container(
                        margin: EdgeInsets.only(top: 30),
                        child: Text(
                          "Manage",
                          style: titleNameStyle,
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.only(top: 30),
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            return ToggleButtons(
                              color: Colors.white,
                              textStyle: TextStyle(
                                fontSize: 18,
                                fontFamily: font,
                              ),
                              renderBorder: false,
                              constraints: BoxConstraints.expand(
                                width: constraints.maxWidth / 3,
                                height: 50,
                              ),
                              borderRadius: borderRadius,
                              children: <Widget>[
                                Text("Employees"),
                                Text("Positions"),
                                Text("Tags"),
                              ],
                              onPressed: (int index) {
                                setState(() {
                                  isSelected = [false, false, false];
                                  isSelected[index] = true;
                                });
                              },
                              isSelected: isSelected,
                            );
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.all(15),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                "Code: " + widget.company.uid,
                                style: inputTextStyle,
                                overflow: TextOverflow.fade,
                                softWrap: false,
                              ),
                            ),
                            IconButton(
                                icon: Icon(
                                  Icons.copy,
                                  color: Colors.grey,
                                ),
                                onPressed: () {
                                  Clipboard.setData(ClipboardData(text: widget.company.uid))
                                      .whenComplete(() => ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                            content: Text(
                                              "Copied to clipboard",
                                              style: TextStyle(fontFamily: font),
                                            ),
                                            duration: Duration(seconds: 1),
                                          )));
                                })
                          ],
                        ),
                      ),
                      _createSearchView(),
                      _createFilteredListView(isSelected.indexOf(true)),
                    ],
                  );
                })),
      ),
    );
  }

  Widget _createSearchView() {
    return Container(
      margin: EdgeInsets.only(top: 10),
      padding: EdgeInsets.only(left: 20),
      decoration: BoxDecoration(
          border: Border.all(
            width: 1.0,
            color: primaryBlue,
          ),
          borderRadius: borderRadius),
      child: TextFormField(
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

  Widget _createFilteredListView(int i) {
    return Expanded(
      child: Container(
        child: ListView.separated(
          shrinkWrap: true,
          itemBuilder: (context, index) {
            if (i == 0) {
              return employeeStaisfy(widget.company.employees[index]) ? buildEmpTile(index) : Container();
            }
            if (i == 1) {
              return widget.company.positions[index].toLowerCase().contains(_query.toLowerCase()) ? buildPosTile(true, index) : Container();
            }
            return widget.company.tags[index].toLowerCase().contains(_query.toLowerCase()) ? buildPosTile(false, index) : Container();
          },
          separatorBuilder: (context, index) {
            if (i == 0) {
              return employeeStaisfy(widget.company.employees[index]) ? SizedBox(height: 20) : Container();
            } else if (i == 1) {
              return widget.company.positions[index].contains(_query)
                  ? SizedBox(
                      child: Divider(color: Colors.white),
                      height: 15,
                    )
                  : Container();
            } else {
              return widget.company.tags[index].contains(_query)
                  ? SizedBox(
                      child: Divider(color: Colors.white),
                      height: 15,
                    )
                  : Container();
            }
          },
          itemCount: i == 0
              ? widget.company.employees.length
              : i == 1
                  ? widget.company.positions.length
                  : widget.company.tags.length,
        ),
      ),
    );
  }

  bool employeeStaisfy(Employee emp) {
    String name = emp.name + ' ' + emp.surname + ' ' + (emp.position != '' ? emp.position : "No position") + (emp.admin ? " admin" : "");
    return (name.toLowerCase().contains(_query.toLowerCase()));
  }

  Widget buildEmpTile(int index) {
    print(index);
    print(widget.company.employees[index].position);
    return Container(
      padding: EdgeInsets.all(5),
      margin: EdgeInsets.only(bottom: 10),
      decoration: secondaryGradientDecoration,
      child: ListTile(
        title: Text(
          widget.company.employees[index].name + ' ' + widget.company.employees[index].surname,
          style: header,
          textAlign: TextAlign.left,
        ),
        trailing: Text(
          widget.company.employees[index].position == "" ? 'No position' : widget.company.employees[index].position,
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
              child: StatefulBuilder(
                builder: (context, setState) {
                  bool innerLoading = false;
                  return innerLoading
                      ? loader
                      : Dialog(
                          shape: dialogShape,
                          backgroundColor: primaryBlue,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                Container(
                                  alignment: Alignment.centerLeft,
                                  padding: EdgeInsets.all(30),
                                  child: Text(
                                    "Position",
                                    style: inputTextStyle.copyWith(fontSize: 22),
                                  ),
                                ),
                                SearchChoices.single(
                                  menuBackgroundColor: Colors.black,
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.white,
                                  ),
                                  clearIcon: Icon(
                                    Icons.clear,
                                    color: Colors.white,
                                  ),
                                  iconSize: 30,
                                  style: inputTextStyle.copyWith(color: Colors.white),
                                  items: positions,
                                  value: widget.company.employees[index].position,
                                  hint: widget.company.employees[index].position == ""
                                      ? Text(
                                          'No position',
                                          style: inputTextStyle,
                                        )
                                      : widget.company.employees[index].position,
                                  searchHint: "Select one",
                                  onChanged: (String value) async {
                                    setState(() {
                                      innerLoading = true;
                                    });
                                    await widget.company.addPositionOrTags(widget.company.employees[index], position: value);
                                    setState(() {
                                      innerLoading = false;
                                    });
                                  },
                                  onClear: () async {
                                    setState(() {
                                      innerLoading = true;
                                    });
                                    await widget.company.addPositionOrTags(widget.company.employees[index], position: "");
                                    setState(() {
                                      innerLoading = false;
                                    });
                                  },
                                  displayItem: (item, selected) => Column(
                                    children: [
                                      SizedBox(height: 20),
                                      Row(
                                        children: [
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
                                        ],
                                      ),
                                    ],
                                  ),
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
                                  menuBackgroundColor: Colors.black,
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    color: Colors.white,
                                  ),
                                  displayClearIcon: false,
                                  iconSize: 30,
                                  style: inputTextStyle.copyWith(color: Colors.white),
                                  items: tags,
                                  hint: 'Add new tag',
                                  searchHint: "Select one",
                                  onChanged: (value) async {
                                    setState(() => innerLoading = true);
                                    List<String> list = [];
                                    value.forEach((element) => list.add(widget.company.tags[element]));
                                    await widget.company.addPositionOrTags(
                                      widget.company.employees[index],
                                      addTags: list,
                                    );
                                    setState(() => innerLoading = false);
                                  },
                                  displayItem: (item, selected) => Column(
                                    children: [
                                      SizedBox(height: 20),
                                      Row(
                                        children: [
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
                                              style: inputTextStyle,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  isExpanded: true,
                                ),
                                Row(
                                  children: [
                                    Container(
                                      padding: EdgeInsets.all(30),
                                      child: Text(
                                        'Admin',
                                        style: inputTextStyle.copyWith(fontSize: 22),
                                      ),
                                    ),
                                    Switch(
                                      value: widget.company.employees[index].admin,
                                      onChanged: (value) async {
                                        setState(() => innerLoading = true);
                                        if (value) {
                                          await widget.company.employees[index].updateEmployee(newAdmin: true);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "You added an admin",
                                                style: TextStyle(
                                                  fontFamily: font,
                                                  fontSize: snackFontSize,
                                                ),
                                              ),
                                              duration: Duration(seconds: 2),
                                            ),
                                          );
                                        } else if (myUid == widget.company.employees[index].uid) {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "You can't remove yourself as admin!",
                                                style: TextStyle(
                                                  fontFamily: font,
                                                  color: Colors.red,
                                                  fontSize: snackFontSize,
                                                ),
                                              ),
                                              duration: Duration(seconds: 2),
                                            ),
                                          );
                                        } else {
                                          await widget.company.employees[index].updateEmployee(newAdmin: false);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            SnackBar(
                                              content: Text(
                                                "You removed an admin",
                                                style: TextStyle(fontFamily: font, fontSize: snackFontSize),
                                              ),
                                              duration: Duration(seconds: 2),
                                            ),
                                          );
                                        }
                                        setState(() => innerLoading = false);
                                      },
                                      activeTrackColor: Colors.deepPurple[900],
                                      activeColor: Colors.white,
                                    ),
                                  ],
                                ),
                                Divider(
                                  thickness: 0.5,
                                  color: Colors.grey,
                                ),
                                Container(
                                  decoration: BoxDecoration(borderRadius: borderRadius),
                                  child: TextButton(
                                    style: textButtonStyleRegister.copyWith(backgroundColor: MaterialStateProperty.all<Color>(Colors.red[700])),
                                    onPressed: () async => await showDialog(
                                      context: context,
                                      builder: (BuildContext context) => myUid == widget.company.employees[index].uid
                                          ? AlertDialog(
                                              title: Text(
                                                "You can not remove yourself from company",
                                                style: TextStyle(fontFamily: font),
                                              ),
                                            )
                                          : AlertDialog(
                                              title: const Text(
                                                "Confirm",
                                                style: TextStyle(
                                                  fontFamily: font,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              content: const Text(
                                                "Are you sure you want to remove this employee from your company?",
                                                style: TextStyle(fontFamily: font),
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () async {
                                                    await widget.company.leaveCompany(widget.company.employees[index]).whenComplete(() {
                                                      _setState();
                                                      setState(() {
                                                        Navigator.of(context).pop();
                                                        Navigator.of(context).pop();
                                                      });
                                                    });
                                                  },
                                                  child: const Text(
                                                    "DELETE",
                                                    style: TextStyle(fontFamily: font),
                                                  ),
                                                ),
                                                TextButton(
                                                  onPressed: () => Navigator.of(context).pop(),
                                                  child: const Text(
                                                    "CANCEL",
                                                    style: TextStyle(fontFamily: font),
                                                  ),
                                                ),
                                              ],
                                            ),
                                    ).whenComplete(() {
                                      setState(() {});
                                    }),
                                    child: Text(
                                      "Remove",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                },
              ),
            ),
          ).whenComplete(() {
            setState(() {});
            loseFocus();
          });
        },
      ),
    );
  }

  Widget buildPosTile(bool pos, int index) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20),
      child: ListTile(
        title: Text(
          pos ? widget.company.positions[index] : widget.company.tags[index],
          style: inputTextStyle,
        ),
        trailing: IconButton(
          icon: Icon(
            Icons.delete,
            color: Colors.white,
          ),
          onPressed: () async => showDialog(
            context: context,
            builder: (BuildContext context) {
              return (pos
                      ? hasPosition(widget.company.positions[index], widget.company.employees)
                      : hasTag(widget.company.tags[index], widget.company.employees))
                  ? AlertDialog(
                      content: Text(
                        pos
                            ? 'You can not remove position because there are still employees with this position.'
                            : 'You can not remove tag because there are still employees with this tag.',
                        style: TextStyle(fontFamily: font),
                      ),
                    )
                  : AlertDialog(
                      title: const Text(
                        "Confirm",
                        style: TextStyle(
                          fontFamily: font,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      content: Text(
                        pos
                            ? "Are you sure you want to remove this position from your company?"
                            : "Are you sure you want to remove this position from your company?",
                        style: TextStyle(fontFamily: font),
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () async {
                            setState(() {
                              loading = true;
                            });
                            await (pos
                                ? widget.company.updateCompany(
                                    newPosition: widget.company.positions[index],
                                    addPosition: false,
                                  )
                                : widget.company.updateCompany(
                                    newTag: widget.company.tags[index],
                                    addTag: false,
                                  ));
                            setState(() {
                              loading = false;
                            });

                            Navigator.of(context).pop();
                          },
                          child: const Text(
                            "DELETE",
                            style: TextStyle(fontFamily: font),
                          ),
                        ),
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text(
                            "CANCEL",
                            style: TextStyle(fontFamily: font),
                          ),
                        ),
                      ],
                    );
            },
          ),
        ),
      ),
    );
  }

  void addPosOrTag() {
    bool pos = isSelected[1] == true;
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: buttonColor,
        child: Container(
          child: TextFormField(
            style: inputTextStyle,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              hintText: pos ? 'Add position' : 'Add tag',
              hintStyle: inputTextStyle.copyWith(color: Colors.grey),
            ),
            onFieldSubmitted: (value) async {
              if (value != "") {
                setState(() {
                  loading = true;
                });
                await (pos
                    ? widget.company.updateCompany(
                        newPosition: value,
                        addPosition: true,
                      )
                    : widget.company.updateCompany(
                        newTag: value,
                        addTag: true,
                      ));
                setState(() {
                  loading = false;
                });
              }
              Navigator.of(context).pop();
            },
          ),
        ),
      ),
    );
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

  void loseFocus() {
    FocusScope.of(context).requestFocus(new FocusNode());
  }

  void _setState() {
    setState(() {});
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
