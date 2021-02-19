import 'package:flutter/material.dart';
import 'package:rankless/log_in.dart';
import 'package:rankless/register.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authenticate> {
  bool showLogIn = true;

  void toogleView() {
    setState(() {
      showLogIn = !showLogIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return showLogIn ? LogIn(toogleView: toogleView) : Register(toogleView: toogleView);
  }
}
