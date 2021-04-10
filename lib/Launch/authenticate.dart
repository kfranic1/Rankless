import 'package:flutter/material.dart';
import 'package:rankless/Ranking/CategoryScreen.dart';
import 'package:rankless/shared/custom_app_bar.dart';
import 'package:rankless/Launch/log_in.dart';
import 'package:rankless/Launch/register.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticationState createState() => _AuthenticationState();
}

class _AuthenticationState extends State<Authenticate> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(),
        body: Center(
          child: ListView(
            children: [
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Register(),
                  ),
                ),
                child: Text('Register'),
              ),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => LogIn(),
                  ),
                ),
                child: Text('Log in'),
              ),
              TextButton(
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CategoryScreen(),
                  ),
                ),
                child: Text('Continue as guest'),
              ),
            ],
          ),
        )

        //showLogIn ? LogIn(toogleView: toogleView) : Register(toogleView: toogleView),
        );
  }
}
