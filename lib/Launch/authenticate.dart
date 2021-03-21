import 'package:flutter/material.dart';
import 'package:rankless/shared/custom_app_bar.dart';
import 'package:rankless/Launch/log_in.dart';
import 'package:rankless/Launch/register.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authenticate> {
  //Show register first
  bool showLogIn = false;

  void toogleView() {
    setState(() {
      showLogIn = !showLogIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleText: showLogIn ? 'Login' : 'Register'),
      body: showLogIn
          ? LogIn(toogleView: toogleView)
          : Register(toogleView: toogleView),
    );
  }
}
