import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:rankless/Company.dart';
import 'package:rankless/Employee.dart';
import 'package:searchable_dropdown/searchable_dropdown.dart';

class JoinCompany extends StatefulWidget {
  Employee employee;
  JoinCompany(this.employee);
  @override
  _JoinCompanyState createState() => _JoinCompanyState();
}

class _JoinCompanyState extends State<JoinCompany> {
  CollectionReference companiesCollection =
      FirebaseFirestore.instance.collection('companies');
  List<SimpleCompany> companies;
  String selectedUid;
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
                    initialData: companies,
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
                              items: companies
                                  .map((e) => DropdownMenuItem(
                                        value: e.uid + '%' + e.name + e.country,
                                        child: ListTile(
                                          title: Text(e.name),
                                          subtitle: Text(e.country),
                                        ),
                                        onTap: () => selectedUid = e.uid,
                                      ))
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
                                selectedUid = item
                                    .toString()
                                    .substring(0, item.toString().indexOf('%'));
                                print(selectedUid);
                              },
                            );
                    },
                  ),
                  FlatButton(
                    color: Colors.green[300],
                    child: Text("Send request"),
                    onPressed: () {
                      setState(() {
                        loading = true;
                        finish();
                      });
                    },
                  ),
                ],
              ),
            ),
    );
  }

  void finish() async {
    print('finishing');
    List<String> req =
        ((await companiesCollection.doc(selectedUid).get())['requests'] as List)
            .map((e) => e.toString())
            .toList();
    print(req);
    req.add(widget.employee.uid);
    await companiesCollection.doc(selectedUid).update({'requests': req});
    Navigator.pop(context);
  }
}

class SimpleCompany {
  String name;
  String country;
  String uid;
  SimpleCompany({this.name, this.country, this.uid});
}
