import 'package:flutter/material.dart';
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
  String email = '';
  String password = '';
  String name = '';
  String surname = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar.build("Register", false),
      body: Center(
        child: Column(
          children: [
            Flexible(
              flex: 10,
              child: Form(
                child: Column(
                  children: [
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      decoration: InputDecoration(hintText: 'name'),
                      onChanged: (value) {
                        setState(() => name = value);
                      },
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
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
                    RaisedButton(
                      child: Text("Register"),
                      onPressed: () async {
                        print(email);
                        print(password);
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
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
