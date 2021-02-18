import 'package:flutter/material.dart';
import 'package:rankless/auth.dart';
import 'package:rankless/custom_app_bar.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final CustomAppBar appBar = CustomAppBar();
  final AuthService _auth = AuthService();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar.build("Sign in", false),
      body: Center(
        child: Container(
          child: RaisedButton(
              child: Text("Continue as guest"),
              onPressed: () async {
                dynamic result = await _auth.signInAnonymus();
                if (result != null) {
                  print("You are a guest");
                }
              }),
        ),
      ),
    );
  }
}
