import 'package:flutter/material.dart';
import 'package:rankless/shared/loader.dart';

const borderRadius = BorderRadius.all(Radius.circular(10));
const font = 'Mulish';
// const whiteColor = Colors.white70;

Loader loader = Loader(color: Colors.blue, allowAnimation: false);

TextStyle inputTextStyle =
    TextStyle(fontFamily: font, color: Colors.white, fontSize: 18);

Decoration popOutDecoration = BoxDecoration(
    borderRadius: borderRadius,
    // color: Colors.blue[300], //Color(0xff42a5f5),
    gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.blue, const Color(0xff3f51b5)]));

const gradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Colors.black, const Color(0xff3f51b5)]);

Decoration backgroundDecoration = BoxDecoration(
    gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Colors.black, const Color(0xff3f51b5)]));

TextStyle surveyNameStyle = TextStyle(
  color: Colors.white,
  fontFamily: 'Mulish',
  fontSize: 25,
  fontWeight: FontWeight.bold,
);

InputDecoration textFieldDecoration = InputDecoration(
  // border: InputBorder.none,
  hintStyle: TextStyle(fontFamily: font, color: Colors.white60, fontSize: 15),
);

InputDecoration registerInputDecoration = textFieldDecoration.copyWith(
  enabledBorder:
      UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
  focusedBorder:
      UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
  errorStyle: TextStyle(fontFamily: font, color: Colors.blue, fontSize: 13),
  errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
  focusedErrorBorder:
      UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
  labelStyle: TextStyle(fontSize: 18, fontFamily: font, color: Colors.white),
);
