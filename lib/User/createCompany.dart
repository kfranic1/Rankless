import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:country_code_picker/country_code_picker.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';
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
  CollectionReference categoriesReference =
      FirebaseFirestore.instance.collection('categories');

  String name = '';
  String info = '';
  String error = '';
  String category = '';
  String country = '';
  bool creating = false;
  List<String> categories;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rankless"),
      ),
      body: creating
          ? Center(child: CircularProgressIndicator())
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
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
                              return value.isEmpty
                                  ? "Name can't be empty"
                                  : null;
                            },
                            decoration:
                                InputDecoration(hintText: 'Company name'),
                            onChanged: (value) {
                              setState(() => name = value);
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          CountryCodePicker(
                            initialSelection: country,
                            showCountryOnly: true,
                            showOnlyCountryWhenClosed: true,
                            onChanged: (value) {
                              setState(() {
                                country = value.toCountryStringOnly();
                              });
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
                              categories =
                                  (value.data()['categories'] as List<dynamic>)
                                      .map((e) => e as String)
                                      .toList();
                            }),
                            builder: (context, snapshot) {
                              categories.sort();
                              categories.add('Other');
                              return DropdownSearch(
                                hint: 'Category',
                                dropdownSearchDecoration: InputDecoration(
                                    border: OutlineInputBorder()),
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
                                  ? "Info can't be empty"
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
                            style: TextStyle(color: Colors.red[400]),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            child: Text("Register Company with this data"),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                setState(() => creating = true);
                                String ret = await finish();
                                if (ret == 'OK') Navigator.pop(context);
                                setState(() {
                                  creating = false;
                                  error = ret;
                                });
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
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
      if (value.size > 0) 
        ret = 'Company with same name and country already exists.';
    });
    if (ret != '') return ret;
    Company company = Company(
      name: this.name,
      industry: this.category,
      employees: [widget.employee],
      description: this.info,
      country: this.country,
      me: widget.employee,
    );
    dynamic result = await company.createCompany();
    if (result is String) return result;
    result = await widget.employee
        .updateEmployee(newRoles: ['admin'], newCompanyUid: company.uid);
    if (result is String) return result;
    return 'OK';
  }
}
