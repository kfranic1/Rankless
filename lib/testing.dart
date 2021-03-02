import 'package:flutter/material.dart';

class Testing extends StatelessWidget {
  final Widget what;
  Testing(this.what);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(),
        body: what,
      ),
    );
  }
}
