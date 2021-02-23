import 'package:flutter/material.dart';

class CreateCompany extends StatefulWidget {
  @override
  _CreateCompanyState createState() => _CreateCompanyState();
}

class _CreateCompanyState extends State<CreateCompany> {
  final _formKey = GlobalKey<FormState>();

  String name = '';
  String adress = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Center(
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
                TextFormField(
                  initialValue: adress,
                  validator: (value) {
                    return value.isEmpty ? "Adress can't be empty" : null;
                  },
                  decoration: InputDecoration(hintText: 'adress'),
                  onChanged: (value) {
                    setState(() => adress = value);
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
    );
  }
}
