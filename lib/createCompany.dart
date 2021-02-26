import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:rankless/Company.dart';
import 'package:rankless/Employee.dart';

class CreateCompany extends StatefulWidget {
  Employee employee;
  CreateCompany(this.employee);
  @override
  _CreateCompanyState createState() => _CreateCompanyState();
}

class _CreateCompanyState extends State<CreateCompany> {
  final _formKey = GlobalKey<FormState>();
  CollectionReference categoriesReference =
      FirebaseFirestore.instance.collection('categories');

  String name = '';
  String info = '';
  String error = '';
  String category = '';
  bool creating = false;
  List<String> categories;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rankless"),
      ),
      body: creating
          ? CircularProgressIndicator()
          : Center(
              child: ListView(
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          initialValue: name,
                          validator: (value) {
                            return value.isEmpty ? "Name can't be empty" : null;
                          },
                          decoration: InputDecoration(hintText: 'name'),
                          onChanged: (value) {
                            setState(() => name = value);
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        FutureBuilder(
                          future: categoriesReference
                              .doc('GSM53sSt5zOWQbndHZH6')
                              .get()
                              .then((value) {
                            categories.clear();
                            value.data().forEach((key, value) {
                              categories.add(value);
                            });
                          }),
                          builder: (context, snapshot) {
                            return DropdownSearch(
                              hint: 'Category',
                              dropdownSearchDecoration:
                                  InputDecoration(border: OutlineInputBorder()),
                              searchDelay: Duration.zero,
                              mode: Mode.MENU,
                              showSearchBox: true,
                              items: categories,
                              onChanged: (index) =>
                                  setState(() => category = index),
                            );
                          },
                          initialData: categories = ["loading"],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          initialValue: info,
                          validator: (value) {
                            return value.isEmpty
                                ? "Adress can't be empty"
                                : null;
                          },
                          decoration: InputDecoration(hintText: 'info'),
                          onChanged: (value) {
                            setState(() => info = value);
                          },
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          error,
                          style: TextStyle(color: Colors.red[350]),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        RaisedButton(
                          child: Text("Register Company with this data"),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() => creating = true);
                              finish();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  void finish() async {
    Company company = Company(
        name: this.name,
        industry: this.category,
        employees: [widget.employee],
        description: this.info);
    dynamic result = await company.createCompany();
    if (result is String) {
      setState(() => error = result);
    } else {
      result = await widget.employee
          .updateEmployee(newRoles: ['admin'], newCompanyUid: company.uid);
      if (result is String) {
        setState(() {
          error = result;
        });
      }
      Navigator.pop(context);
    }
  }
}
