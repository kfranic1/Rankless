import 'package:flutter/material.dart';
import 'package:rankless/auth.dart';
import 'package:rankless/custom_app_bar.dart';

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

  String email = '';
  String password = '';
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
                        initialValue: email,
                        decoration: InputDecoration(hintText: "email"),
                        onChanged: (value) {
                          setState(() => email = value);
                        },
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      TextFormField(
                        initialValue: password,
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
                            setState(() => loading = true);
                            dynamic result = await _auth
                                .logInWithEmailAndPassword(email, password);
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
                      SizedBox(
                        height: 20,
                      ),
                      FlatButton(
                          onPressed: widget.toogleView,
                          child: Text("Don't have an account? Register here."))
                    ],
                  ),
                ),
              ],
            ),
          );
  }
}
