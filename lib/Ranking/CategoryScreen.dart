// import 'dart:html';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rankless/shared/Interface.dart';
import 'package:rankless/Ranking/RankingScreen.dart';

class CategoryScreen extends StatefulWidget {
  @override
  _CategoryScreenState createState() => _CategoryScreenState();
}

class _CategoryScreenState extends State<CategoryScreen> {
  String category = '';

  @override
  Widget build(BuildContext context) {
    print('categScr: $category');
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 60),
      child: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) => Container(
          child: TextButton(
            onPressed: () {
              setState(() {
                category = categories[index];
                Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RankingScreen(category),
                    ));
              });
            },
            child: Text(
              categories[index],
              style: inputTextStyle.copyWith(fontSize: 20),
              textAlign: TextAlign.center, // za service activities
            ),
            style: ButtonStyle(
              // overlayColor: MaterialStateProperty.all<Color>(Colors.transparent),
              padding: MaterialStateProperty.all<EdgeInsetsGeometry>(EdgeInsets.all(40)),
            ),
          ),
          // padding: EdgeInsets.all(40),
          margin: EdgeInsets.all(30),
          decoration: popOutDecoration,
          alignment: Alignment.center,
        ),
      ),
    );
  }
}
