import 'package:flutter/material.dart';

const borderRadius = BorderRadius.all(Radius.circular(10));
const font = 'Mulish';
// const whiteColor = Colors.white70;

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
