import 'package:flutter/material.dart';
import 'package:rankless/sign_in.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authenticate> {
  @override
  Widget build(BuildContext context) {
    return SignIn();
  }
}
