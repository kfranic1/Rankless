import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:rankless/Company.dart';
import 'package:rankless/Employee.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class JoinCompany extends StatefulWidget {
  final Employee employee;
  JoinCompany(this.employee);
  @override
  _JoinCompanyState createState() => _JoinCompanyState();
}

class _JoinCompanyState extends State<JoinCompany> {
  CollectionReference companiesCollection =
      FirebaseFirestore.instance.collection('companies');
  List<SimpleCompany> companies;
  String selectedUid;
  String selectedCompany;
  bool loading = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rankless"),
      ),
      body: loading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  FutureBuilder(
                    initialData: null,
                    future: companies == null
                        ? companiesCollection.get().then((value) => {
                              companies = value.docs
                                  .map((e) => SimpleCompany(
                                      name: e.data()['name'],
                                      uid: e.id,
                                      country: e.data()['country']))
                                  .toList()
                            })
                        : null,
                    builder: (context, snapshot) {
                      return (!snapshot.hasData)
                          ? Center(child: CircularProgressIndicator())
                          : SearchableDropdown.single(
                              displayClearIcon: false,
                              items: companies
                                  .map(
                                    (e) => DropdownMenuItem(
                                      value: e.uid +
                                          '%' +
                                          e.name +
                                          '%' +
                                          e.country,
                                      child: ListTile(
                                        title: Text(e.name),
                                        subtitle: Text(e.country),
                                      ),
                                    ),
                                  )
                                  .toList(),
                              hint: Text(
                                'Company',
                                style: TextStyle(
                                    color: Colors.grey[600],
                                    fontFamily: 'Mulish',
                                    fontSize: 15),
                              ),
                              searchHint: 'What is your company',
                              isExpanded: true,
                              onChanged: (item) {
                                String temp = item as String;
                                setState(() {
                                  selectedCompany = temp.substring(
                                      temp.indexOf('%') + 1,
                                      temp.lastIndexOf('%'));
                                  selectedUid =
                                      temp.substring(0, temp.indexOf('%'));
                                });
                              },
                            );
                    },
                  ),
                  SizedBox(height: 20),
                  FlatButton(
                    color: Colors.green[300],
                    child: Text("Send request"),
                    onPressed: () {
                      setState(() {
                        loading = true;
                        widget.employee
                            .sendRequestToCompany(selectedCompany, selectedUid);
                        Navigator.pop(context);
                      });
                    },
                  ),
                ],
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
