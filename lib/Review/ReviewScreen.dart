import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rankless/User/Company.dart';
import 'package:rankless/shared/Interface.dart';
import 'package:search_choices/search_choices.dart';
import 'Analysis.dart';

class ReviewScreen extends StatefulWidget {
  @override
  _ReviewScreenState createState() => _ReviewScreenState();
}

class _ReviewScreenState extends State<ReviewScreen> {
  List<DropdownMenuItem<String>> searchCountries;
  String selectedCountry;
  List<DropdownMenuItem<String>> searchCategories;
  bool loading = false;
  Company company;
  Analysis analysis;
  Future _future;
  @override
  void initState() {
    company = Provider.of<Company>(context, listen: false);
    analysis = Analysis(company.uid);
    _future = analysis.getData().whenComplete(() => searchCountries = analysis.activeCountries.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // searchCategories = categories.map<DropdownMenuItem<String>>((String value) {
    //   return DropdownMenuItem<String>(value: value, child: Text(value));
    // }).toList();

    return Scaffold(
      body: Container(
        decoration: backgroundDecoration,
        height: double.infinity,
        width: double.infinity,
        child: FutureBuilder(
            future: _future,
            builder: (context, snapshot) {
              if (snapshot.connectionState != ConnectionState.done) return loader;
              return Column(
                // shrinkWrap: true,
                children: [
                  Text(
                    'Industry: ' + company.industry,
                    style: inputTextStyle,
                  ),
                  SearchChoices.single(
                    menuBackgroundColor: Colors.white,
                    items: searchCountries,
                    value: selectedCountry,
                    hint: selectedCountry == null
                        ? Text(
                            'hint',
                            style: inputTextStyle,
                          )
                        : selectedCountry,
                    searchHint: 'search hint',
                    isExpanded: true,
                    onChanged: (value) {
                      print(value);
                      setState(() {
                        selectedCountry = value;
                      });
                    },
                  ),
                ],
              );
            }),
      ),
    );
  }
}
