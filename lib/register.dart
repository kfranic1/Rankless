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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar.build("Register", employee),
      body: Center(
        child: ListView(
          children: [
            Flexible(
              flex: 10,
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
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
                      validator: (value) {
                        return value.isEmpty ? "Surname can't be empty" : null;
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
                      decoration: InputDecoration(hintText: 'email'),
                      onChanged: (value) {
                        setState(() => email = value);
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      decoration: InputDecoration(hintText: 'password'),
                      obscureText: true,
                      onChanged: (value) {
                        setState(() => password = value);
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(error),
                    SizedBox(
                      height: 20,
                    ),
                    RaisedButton(
                      child: Text("Register"),
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          dynamic result = await _auth
                              .registerWithEmailAndPassword(email, password);
                          if (result == null) {
                            setState(() {
                              error = result;
                            });
                          }
                          //automatic homescreen from stream
                        }
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    FlatButton(
                      child: Text("Already have an acount? Log in here."),
                      onPressed: widget.toogleView,
                    )
                  ],
                ),
              ),
            ),
            FlatButton(
              child: Text("Continue as guest"),
              onPressed: () async {
                dynamic result = await _auth.signInAnonymus();
                if (result != null) {
                  print("You are a guest");
                } else {
                  employee = result;
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
