import 'package:flutter/material.dart';
import 'package:rankless/Launch/auth.dart';
import 'package:rankless/shared/Interface.dart';
import 'package:rankless/shared/custom_app_bar.dart';

class LogIn extends StatefulWidget {
  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String error = '';
  bool loading = false;
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleText: 'Login',
      ),
      body: Container(
        decoration: backgroundDecoration,
        padding: EdgeInsets.all(20),
        child: loading
            ? loader
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
                            decoration: registerInputDecoration.copyWith(labelText: "email"),
                            style: inputTextStyle,
                            onChanged: (value) {
                              setState(() => email = value);
                            },
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          ListTile(
                            contentPadding: EdgeInsets.all(0),
                            title: TextFormField(
                              initialValue: password,
                              decoration: registerInputDecoration.copyWith(labelText: "password"),
                              style: inputTextStyle,
                              obscureText: obscureText,
                              onChanged: (value) {
                                setState(() => password = value);
                              },
                            ),
                            trailing: IconButton(
                              icon: Icon(Icons.remove_red_eye, color: Colors.white),
                              onPressed: () {
                                setState(() {
                                  obscureText = !obscureText;
                                });
                              },
                            ),
                          ),
                          SizedBox(
                            height: 20,
                          ),
                          Text(error, style: inputTextStyle.copyWith(fontSize: 12, color: Colors.blue)),
                          SizedBox(
                            height: 20,
                          ),
                          ElevatedButton(
                            child: Text("Log In", style: inputTextStyle),
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                _formKey.currentState.setState(() => loading = true);
                                dynamic result = await _auth.logInWithEmailAndPassword(email, password);
                                if (result is String) {
                                  setState(() {
                                    error = result;
                                    loading = false;
                                  });
                                } else {
                                  Navigator.pop(context);
                                }
                                //automatic homescreen from stream
                              }
                            },
                            style: textButtonStyleRegister,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }
}
