import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

const borderRadius = BorderRadius.all(Radius.circular(10));
const font = 'Mulish';
// const whiteColor = Colors.white70;

Widget loader = Center(child: CircularProgressIndicator()) /*Loader(color: Colors.blue, allowAnimation: false)*/;

//VARIABLES

const double e = 1e-9;

List<String> industries = [
  "Auto-Moto",
  "Construction",
  "Education",
  "Health",
  "Fashion",
  "Finance",
  "Real Estate",
  "Science",
  "Service activities",
  "Sport",
  "Technology",
  "Tourism",
  "Other",
];

List<String> categories = [
  "Engagement",
  "Performance",
  "Satisfaction",
  "Prospects",
  'Other',
];

List<String> months = [
  'Jan',
  'Feb',
  'Mar',
  'Apr',
  'May',
  'Jun',
  'Jul',
  'Aug',
  'Sep',
  'Oct',
  'Nov',
  'Dec',
];

// ? #collections
CollectionReference companiesCollection = FirebaseFirestore.instance.collection('companies');
CollectionReference userCollection = FirebaseFirestore.instance.collection('users');
CollectionReference surveyCollection = FirebaseFirestore.instance.collection('surveys');
CollectionReference resultCollection = FirebaseFirestore.instance.collection('results');
CollectionReference publicCollection = FirebaseFirestore.instance.collection('public');
// ? #end collections

// COLORS
const primaryGradient = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.black, const Color(0xff3f51b5)]);
const secondaryGradient = LinearGradient(begin: Alignment.topCenter, end: Alignment.bottomCenter, colors: [Colors.blue, const Color(0xff3f51b5)]);
const primaryBlue = Colors.blue;
const secondaryBlue = Colors.blueAccent;
Color buttonColor = Colors.blue.withOpacity(0.7);

// DECORATIONS
Decoration secondaryGradientDecoration = BoxDecoration(
  borderRadius: borderRadius,
  gradient: secondaryGradient,
);

BoxDecoration popOutDecoration = BoxDecoration(
  borderRadius: borderRadius,
  color: primaryBlue,
);

Decoration backgroundDecoration = BoxDecoration(gradient: primaryGradient);

// BoxDecoration borderDecoration = BoxDecoration(borderRadius: borderRadius);

InputDecoration textFieldDecoration = InputDecoration(
  // border: InputBorder.none,
  hintStyle: TextStyle(fontFamily: font, color: Colors.white60, fontSize: 15),
);

InputDecoration registerInputDecoration = textFieldDecoration.copyWith(
  enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
  focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
  errorStyle: TextStyle(fontFamily: font, color: Colors.blue, fontSize: 13),
  errorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
  focusedErrorBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.blue)),
  labelStyle: TextStyle(fontSize: 18, fontFamily: font, color: Colors.white),
);

// STYLES
TextStyle titleNameStyle = TextStyle(
  color: Colors.white,
  fontFamily: 'Mulish',
  fontSize: 25,
  fontWeight: FontWeight.bold,
);

TextStyle inputTextStyle = TextStyle(
  fontFamily: font,
  color: Colors.white,
  fontSize: 18,
);

const double snackFontSize = 18;

RoundedRectangleBorder dialogShape = RoundedRectangleBorder(borderRadius: borderRadius);

// BUTTONS
ButtonStyle textButtonStyleRegister = ButtonStyle(
    // elevation: MaterialStateProperty.all<double>(5.0),
    backgroundColor: MaterialStateProperty.all<Color>(buttonColor),
    shape: MaterialStateProperty.all<OutlinedBorder>(
      RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20)),
      ),
    ),
    // side: MaterialStateProperty.all<BorderSide>(BorderSide(width: 1, color: Colors.white)),
    padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.only(top: 10, bottom: 10, left: 15, right: 15))
    // minimumSize: MaterialStateProperty.all<Size>(Size(30, 8)),
    );

int getFromMask(int mask) {
  return (log(mask) / log(2)).round();
}
