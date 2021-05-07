import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rankless/shared/Interface.dart';
import 'package:rankless/shared/custom_app_bar.dart';
import 'package:search_choices/search_choices.dart';
import 'Employee.dart';

class JoinCompany extends StatefulWidget {
  final Employee employee;
  JoinCompany(this.employee);
  @override
  _JoinCompanyState createState() => _JoinCompanyState();
}

class _JoinCompanyState extends State<JoinCompany> {
  CollectionReference companiesCollection = FirebaseFirestore.instance.collection('companies');
  List<SimpleCompany> companies;
  String selectedUid;
  String selectedCompany;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(show: false),
      body: Container(
        decoration: backgroundDecoration,
        child: loading
            ? Center(child: CircularProgressIndicator())
            : Padding(
                padding: const EdgeInsets.all(8.0),
                child: FutureBuilder(
                  initialData: null,
                  future: companies == null
                      ? companiesCollection.get().then((value) => {
                            companies = value.docs.map((e) => SimpleCompany(name: e.data()['name'], uid: e.id, country: e.data()['country'])).toList()
                          })
                      : null,
                  builder: (context, snapshot) {
                    return (!snapshot.hasData)
                        ? Center(child: CircularProgressIndicator())
                        : Column(
                            children: [
                              Theme(
                                data: ThemeData(
                                  textSelectionTheme: TextSelectionThemeData(
                                    cursorColor: Colors.white,
                                  ),
                                  primaryColor: Colors.white,
                                  hintColor: Colors.white,
                                ),
                                child: SearchChoices.single(
                                  displayClearIcon: false,
                                  items: companies
                                      .map(
                                        (e) => DropdownMenuItem(
                                          value: e.uid + '%' + e.name + '%' + e.country,
                                          child: ListTile(
                                            title: Text(e.name, style: inputTextStyle),
                                            subtitle: Text(
                                              e.country,
                                              style: inputTextStyle.copyWith(fontSize: 15),
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                  menuBackgroundColor: Colors.blue,
                                  hint: Text(
                                    'Company',
                                    style: inputTextStyle,
                                  ),
                                  style: inputTextStyle,
                                  isExpanded: true,
                                  onChanged: (item) {
                                    String temp = item as String;
                                    setState(() {
                                      selectedCompany = temp.substring(temp.indexOf('%') + 1, temp.lastIndexOf('%'));
                                      selectedUid = temp.substring(0, temp.indexOf('%'));
                                    });
                                  },
                                ),
                              ),
                              SizedBox(height: 20),
                              Container(
                                padding: EdgeInsets.all(10),
                                child: TextButton(
                                  child: Text(
                                    "Send request",
                                    style: inputTextStyle,
                                  ),
                                  onPressed: () {
                                    if (selectedCompany == null) return;
                                    setState(() {
                                      loading = true;
                                      //widget.employee.sendRequestToCompany(selectedCompany, selectedUid);
                                      Navigator.pop(context);
                                    });
                                  },
                                  style: textButtonStyleRegister,
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
}

class SimpleCompany {
  String name;
  String country;
  String uid;
  SimpleCompany({this.name, this.country, this.uid});
}
