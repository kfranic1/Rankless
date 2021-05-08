import 'package:flutter/material.dart';
import 'package:rankless/Launch/auth.dart';
import 'package:rankless/Launch/log_in.dart';
import 'package:rankless/shared/Interface.dart';
import 'package:rankless/shared/custom_app_bar.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  String email = '';
  String password = '';
  String confPass = '';
  String name = '';
  String surname = '';
  String error = '';
  bool loading = false;
  bool obscureText = true;
  bool obscureText2 = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(titleText: 'Register'),
      body: Container(
        height: double.infinity,
        decoration: backgroundDecoration,
        padding: EdgeInsets.all(15),
        child: loading
            ? loader
            : ListView(
                shrinkWrap: true,
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(height: 20),
                        TextFormField(
                          initialValue: name,
                          validator: (value) {
                            return (value.isEmpty || value.contains('%')) ? "Name can't be empty or contain %" : null;
                          },
                          onChanged: (value) => setState(() => name = value),
                          // textCapitalization: TextCapitalization.words,
                          decoration: registerInputDecoration.copyWith(labelText: 'name'),
                          style: inputTextStyle,
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          initialValue: surname,
                          validator: (value) => (value.isEmpty || value.contains('%')) ? "Surname can't be empty" : null,
                          onChanged: (value) => setState(() => surname = value),
                          decoration: registerInputDecoration.copyWith(labelText: 'surname'),
                          style: inputTextStyle,
                        ),
                        SizedBox(height: 20),
                        TextFormField(
                          initialValue: email,
                          decoration: registerInputDecoration.copyWith(labelText: 'email'),
                          style: inputTextStyle,
                          onChanged: (value) => setState(() => email = value),
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) => (!value.contains('@')) ? 'Not a valid email address' : null,
                        ),
                        SizedBox(height: 20),
                        ListTile(
                          contentPadding: EdgeInsets.all(0),
                          title: TextFormField(
                            initialValue: password,
                            decoration: registerInputDecoration.copyWith(labelText: 'password'),
                            style: inputTextStyle,
                            obscureText: obscureText,
                            onChanged: (value) => setState(() => password = value),
                          ),
                        ),
                        SizedBox(height: 10),
                        ListTile(
                          contentPadding: EdgeInsets.all(0),
                          title: TextFormField(
                            initialValue: confPass,
                            decoration: registerInputDecoration.copyWith(
                              labelText: 'confirm password',
                            ),
                            style: inputTextStyle,
                            obscureText: obscureText,
                            onChanged: (value) => setState(() => confPass = value),
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            validator: (value) => (value != password) ? 'Passwords don’t match.' : null,
                          ),
                          trailing: IconButton(
                            icon: Icon(Icons.remove_red_eye, color: Colors.white),
                            onPressed: () => setState(() => obscureText = !obscureText),
                          ),
                        ),
                        SizedBox(height: 10),
                        Text(
                          error,
                          style: TextStyle(color: Colors.red[350]),
                        ),
                        SizedBox(height: 10),
                        TextButton(
                          child: Text(
                            "Register",
                            style: inputTextStyle,
                          ),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() => loading = true);
                              dynamic result = await _auth.registerWithEmailAndPassword(
                                email,
                                password,
                                name,
                                surname,
                              );
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
                  SizedBox(height: 20),
                  TextButton(
                    child: RichText(
                        text: new TextSpan(style: inputTextStyle, children: <TextSpan>[
                      new TextSpan(text: 'Already have an acount? '),
                      new TextSpan(text: 'Log in', style: TextStyle(fontWeight: FontWeight.bold))
                    ])),
                    onPressed: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => LogIn(),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
