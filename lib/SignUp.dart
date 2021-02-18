import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          TextFormField(
            decoration: const InputDecoration(hintText: "Input email"),
          ),
          TextFormField(
            obscureText: true,
            decoration: const InputDecoration(hintText: "Input password"),
          ),
          ElevatedButton(onPressed: () {}, child: Text("Sign up")),
        ],
      ),
    );
  }
}
