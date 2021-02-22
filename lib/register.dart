import 'package:flutter/material.dart';
import 'package:rankless/Employee.dart';
import 'package:rankless/auth.dart';

import 'custom_app_bar.dart';

class Register extends StatefulWidget {
  final Function toogleView;
  Register({this.toogleView});
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final CustomAppBar appBar = CustomAppBar();
  final _formKey = GlobalKey<FormState>();

  Employee employee;

  String email = '';
  String password = '';
  String name = '';
  String surname = '';
  String error = '';
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    return loading
        //TODO swap with custom loader
        ? Center(
            child: CircularProgressIndicator(),
          )
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
                      TextFormField(
                        initialValue: surname,
                        validator: (value) {
                          return value.isEmpty
                              ? "Surname can't be empty"
                              : null;
                        },
                        decoration: InputDecoration(hintText: 'surname'),
                        onChanged: (value) {
                          setState(() => surname = value);
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        initialValue: email,
                        decoration: InputDecoration(hintText: 'email'),
                        onChanged: (value) {
                          setState(() => email = value);
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        initialValue: password,
                        decoration: InputDecoration(hintText: 'password'),
                        obscureText: true,
                        onChanged: (value) {
                          setState(() => password = value);
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
                        child: Text("Register"),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            setState(() => loading = true);
                            dynamic result = await _auth
                                .registerWithEmailAndPassword(email, password);
                            if (result is String) {
                              setState(() {
                                error = result;
                                loading = false;
                              });
                            }
                            //automatic homescreen from stream
                          }
                        },
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                FlatButton(
                  child: Text("Already have an acount? Log in here."),
                  onPressed: widget.toogleView,
                ),
                SizedBox(
                  height: 20,
                ),
                FlatButton(
                  child: Text("Continue as guest"),
                  onPressed: () async {
                    setState(() => loading = true);
                    dynamic result = await _auth.signInAnonymus();
                    if (result is String) {
                      setState(() {
                        error = result;
                        loading = false;
                      });
                    }
                  },
                ),
              ],
            ),
          );
  }
}
