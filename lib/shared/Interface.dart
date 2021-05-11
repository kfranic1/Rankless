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
  "IT",
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
  "Work environment",
  "Prospects",
];

List<String> categoryDescriptions = [
  'Engagement - how passionate people are about their work and commited to their organization', //'Employee engagement is the extent to which employees feel passionate about their jobs, are committed to the organization, and put discretionary effort into their work.',

  'Performance - how employees behave in the workplace and how well they perform their duties',
  'Satisfaction - do employees feel recognized, properly rewarded for their work and content with their responsibilities' //employee recognition and factors such as job stability', //'how happy or content your employees are'
  ,
  'Work environment - conditions employees work in and relationships with their co-workers',
  'Prospects - how much people feel they can develop and advance in their company',
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
const shadedWhite = Colors.white70; // used for icons in multiple answers types

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

Decoration lighterContainerDecoration = BoxDecoration(
  borderRadius: borderRadius,
  color: Colors.white.withOpacity(0.4),
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

TextStyle header = TextStyle(
  fontFamily: font,
  color: Colors.white,
  fontSize: 20,
);

const double snackFontSize = 18;
const double nameFontSize = 30;

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
