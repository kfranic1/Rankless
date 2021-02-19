import 'package:flutter/material.dart';
import 'package:rankless/Employee.dart';
import 'package:rankless/auth.dart';
import 'package:rankless/custom_app_bar.dart';

import 'register.dart';

class LogIn extends StatefulWidget {
  final Function toogleView;
  LogIn({this.toogleView});
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final CustomAppBar appBar = CustomAppBar();
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  Employee employee;

  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar.build("Log in", employee),
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
                    decoration: InputDecoration(hintText: "email"),
                    onChanged: (value) {
                      setState(() => email = value);
                    },
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: InputDecoration(hintText: "password"),
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
                    child: Text("Log In"),
                    onPressed: () async {
                      if (_formKey.currentState.validate()) {
                        dynamic result = await _auth.logInWithEmailAndPassword(
                            email, password);
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
                      onPressed: widget.toogleView,
                      child: Text("Don't have an account? Register here."))
                ],
              ),
            ),
            SizedBox(
              height: 50,
            ),
            FlatButton(
              child: Text("Continue as guest"),
              onPressed: () async {
                dynamic result = await _auth.signInAnonymus();
                if (result != null) {
                  print("You are a guest");
                } else {
                  setState(() {
                    employee = result;
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
