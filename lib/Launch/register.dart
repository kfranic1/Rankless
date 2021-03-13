import 'package:flutter/material.dart';
import 'package:rankless/Launch/auth.dart';
import 'package:rankless/shared/Interface.dart';

// TextStyle inputTextStyle =
//     TextStyle(fontFamily: font, color: Colors.white, fontSize: 18);

// InputDecoration registerInputDecoration = textFieldDecoration.copyWith(
//   enabledBorder:
//       UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
//   focusedBorder:
//       UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
//   errorStyle: TextStyle(fontFamily: font, color: Colors.blue, fontSize: 13),
//   errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
//   focusedErrorBorder:
//       UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
//   labelStyle: TextStyle(fontSize: 18, fontFamily: font, color: Colors.white),
// );

class Register extends StatefulWidget {
  final Function toogleView;
  Register({this.toogleView});
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
    return Container(
      decoration: backgroundDecoration,
      padding: EdgeInsets.all(15),
      child: loading
          //TODO swap with custom loader
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Center(
              child: ListView(
                shrinkWrap: true,
                children: [
                  Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          initialValue: name,
                          validator: (value) {
                            return (value.isEmpty || value.contains('%'))
                                ? "Name can't be empty or contain %"
                                : null;
                          },
                          onChanged: (value) {
                            setState(() => name = value);
                          },
                          // textCapitalization: TextCapitalization.words,
                          decoration: registerInputDecoration.copyWith(
                              labelText: 'name'),
                          style: inputTextStyle,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          initialValue: surname,
                          validator: (value) {
                            return (value.isEmpty || value.contains('%'))
                                ? "Surname can't be empty"
                                : null;
                          },
                          onChanged: (value) {
                            setState(() => surname = value);
                          },
                          decoration: registerInputDecoration.copyWith(
                              labelText: 'surname'),
                          style: inputTextStyle,
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        TextFormField(
                          initialValue: email,
                          decoration: registerInputDecoration.copyWith(
                              labelText: 'email'),
                          style: inputTextStyle,
                          onChanged: (value) {
                            setState(() => email = value);
                          },
                          autovalidateMode: AutovalidateMode.onUserInteraction,
                          validator: (value) {
                            return (!value.contains('@'))
                                ? 'Not a valid email address'
                                : null;
                          },
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.all(0),
                          title: TextFormField(
                            initialValue: password,
                            decoration: registerInputDecoration.copyWith(
                                labelText: 'password'),
                            style: inputTextStyle,
                            obscureText: obscureText,
                            onChanged: (value) {
                              setState(() => password = value);
                            },
                          ),
                          // trailing: IconButton(          // ako zelimo 2 gumba
                          //   icon:
                          //       Icon(Icons.remove_red_eye, color: Colors.white),
                          //   onPressed: () {
                          //     setState(() {
                          //       obscureText = !obscureText;
                          //     });
                          //   },
                          // ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.all(0),
                          title: TextFormField(
                            initialValue: confPass,
                            decoration: registerInputDecoration.copyWith(
                              labelText: 'confirm password',
                              // errorStyle: TextStyle(color: Colors.yellow),
                              // errorBorder: UnderlineInputBorder(
                              //     borderSide:
                              //         BorderSide(color: Colors.yellow))
                            ),
                            style: inputTextStyle,
                            obscureText: obscureText,
                            onChanged: (value) {
                              setState(() => confPass = value);
                            },
                            autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                            validator: (value) {
                              return (value != password)
                                  ? 'Passwords don’t match.'
                                  : null;
                            },
                          ),
                          trailing: IconButton(
                            icon:
                                Icon(Icons.remove_red_eye, color: Colors.white),
                            onPressed: () {
                              setState(() {
                                obscureText = !obscureText;
                              });
                            },
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          error,
                          style: TextStyle(color: Colors.red[350]),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        ElevatedButton(
                          child: Text(
                            "Register",
                            style: inputTextStyle,
                          ),
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              setState(() => loading = true);
                              dynamic result =
                                  await _auth.registerWithEmailAndPassword(
                                      email, password, name, surname);
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
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextButton(
                    child: Text("Already have an acount? Log in here.",
                        style: inputTextStyle),
                    onPressed: widget.toogleView,
                  ),
                  SizedBox(
                    height: 20,
                  ),
                  TextButton(
                    child: Text("Continue as guest", style: inputTextStyle),
                    onPressed: () async {
                      setState(() => loading = true);
                      dynamic result = await _auth.signInAnonymus();
                      if (result is String) {
                        setState(() {
                          error = result;
                          loading = false;
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
