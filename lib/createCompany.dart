import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_search/dropdown_search.dart';

class CreateCompany extends StatefulWidget {
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
  List<String> categories;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Rankless"),
      ),
      body: Center(
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
                        mode: Mode.MENU,
                        showSearchBox: true,
                        items: categories,
                        onChanged: (index) =>
                            setState(() => category = categories[index]),
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
                      return value.isEmpty ? "Adress can't be empty" : null;
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
                        setState(() => {});
                        dynamic result = await null;
                        if (result is String) {
                          setState(() {
                            error = result;
                          });
                        }
                        //automatic homescreen from stream
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
}
