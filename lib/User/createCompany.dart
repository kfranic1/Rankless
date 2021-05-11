import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:rankless/shared/Interface.dart';
import 'package:rankless/shared/custom_app_bar.dart';
import 'package:search_choices/search_choices.dart';
import 'Company.dart';
import 'Employee.dart';

class CreateCompany extends StatefulWidget {
  final Employee employee;
  CreateCompany(this.employee);
  @override
  _CreateCompanyState createState() => _CreateCompanyState();
}

class _CreateCompanyState extends State<CreateCompany> {
  final _formKey = GlobalKey<FormState>();
  CollectionReference industriesReference = FirebaseFirestore.instance.collection('industries');

  String name = '';
  String error = '';
  String industry = '';
  String country = 'Hrvatska';
  bool creating = false;

  @override
  Widget build(BuildContext context) {
    print(industries);
    return Scaffold(
      appBar: CustomAppBar(show: false),
      body: Container(
        decoration: backgroundDecoration,
        padding: EdgeInsets.all(20),
        child: creating
            ? loader
            : Theme(
                data: ThemeData(
                  textSelectionTheme: TextSelectionThemeData(
                    cursorColor: Colors.white,
                    selectionColor: Colors.white,
                    selectionHandleColor: Colors.white,
                  ),
                  primaryColor: Colors.black45,
                  hintColor: Colors.white, // boja naziva dropdowna
                  fontFamily: font,
                ),
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView(
                      children: [
                        Form(
                          key: _formKey,
                          child: Column(
                            children: [
                              SizedBox(height: 20),
                              TextFormField(
                                initialValue: name,
                                validator: (value) => value.isEmpty ? "Name can't be empty" : null,
                                decoration: registerInputDecoration.copyWith(labelText: 'Company name'),
                                style: inputTextStyle,
                                onChanged: (value) => setState(() => name = value),
                              ),
                              SizedBox(height: 30),
                              CountryCodePicker(
                                initialSelection: country,
                                showCountryOnly: true,
                                showOnlyCountryWhenClosed: true,
                                onChanged: (value) => setState(() => country = value.name),
                                backgroundColor: Colors.black.withOpacity(0.7),
                                dialogBackgroundColor: Colors.teal[200],
                                barrierColor: Colors.transparent, //blue[900],
                                dialogTextStyle: inputTextStyle,
                                textStyle: inputTextStyle,
                                searchStyle: inputTextStyle.copyWith(color: Colors.black),
                                searchDecoration: registerInputDecoration.copyWith(hintStyle: TextStyle(color: Colors.white)),
                                boxDecoration: popOutDecoration,
                              ),
                              SizedBox(height: 20),
                              SearchChoices.single(
                                hint: 'industry',
                                value: industry,
                                style: inputTextStyle.copyWith(color: Colors.white),
                                menuBackgroundColor: Colors.blueAccent,
                                isExpanded: true,
                                items: industries
                                    .map(
                                      (e) => DropdownMenuItem(
                                        value: e,
                                        child: Text(
                                          e,
                                          style: inputTextStyle,
                                        ),
                                      ),
                                    )
                                    .toList(),
                                onChanged: (index) => setState(() => industry = index),
                              ),
                              SizedBox(height: 10),
                              Text(
                                error,
                                style: TextStyle(color: Colors.red[400]),
                              ),
                              SizedBox(height: 10),
                              TextButton(
                                child: Text(
                                  "Register Company with this data",
                                  style: inputTextStyle,
                                ),
                                onPressed: () async {
                                  if (_formKey.currentState.validate()) {
                                    setState(() => creating = true);
                                    String ret = await finish();
                                    if (ret == 'OK')
                                      Navigator.pop(context);
                                    else {
                                      setState(() {
                                        creating = false;
                                        error = ret;
                                      });
                                    }
                                  }
                                },
                                style: textButtonStyleRegister,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Future<String> finish() async {
    String ret = '';
    await FirebaseFirestore.instance
        .collection('companies')
        .where('name', isEqualTo: this.name)
        .where('country', isEqualTo: this.country)
        .get()
        .then((value) {
      if (value.size > 0) ret = 'Company with same name and country already exists.';
    });
    if (ret != '') return ret;
    Company company = Company(
      name: this.name,
      industry: this.industry,
      employees: [widget.employee],
      country: this.country,
    );
    dynamic result = await company.createCompany();
    if (result is String) return result;
    result = await widget.employee.updateEmployee(newAdmin: true, newCompanyUid: company.uid);
    if (result is String) return result;
    return 'OK';
  }
}
