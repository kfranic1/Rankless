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
  DropdownMenuItem selectedCountry;
  List<DropdownMenuItem<String>> searchCategories;
  bool loading = false;

  @override
  Widget build(BuildContext context) {
    Company company = Provider.of<Company>(context);
    Analysis analysis = Analysis(company.uid);

    // searchCategories = categories.map<DropdownMenuItem<String>>((String value) {
    //   return DropdownMenuItem<String>(value: value, child: Text(value));
    // }).toList();

    return Scaffold(
      body: Container(
        decoration: backgroundDecoration,
        height: double.infinity,
        width: double.infinity,
        // TODO pozivaj future jednom
        child: FutureBuilder(
            future: analysis.getData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.active) return loader;
              // else
              searchCountries = analysis.activeCountries.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList();

              searchCountries.forEach((element) {
                print('el ${element.value}');
              });
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
                    displayItem: (item, selected) {
                      return Column(children: [
                        SizedBox(height: 20),
                        Row(children: [
                          selected
                              ? Icon(
                                  Icons.check,
                                  color: Colors.green,
                                )
                              : Icon(
                                  Icons.check_box_outline_blank,
                                  color: Colors.grey,
                                ),
                          SizedBox(width: 7),
                          Expanded(
                            child: Text(
                              item.value,
                              style: inputTextStyle,
                            ),
                          ),
                        ]),
                      ]);
                    },
                    isExpanded: true,
                  ),
                ],
              );
            }),
      ),
    );
  }
}
