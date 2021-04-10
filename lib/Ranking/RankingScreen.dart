import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rankless/shared/Interface.dart';
import 'package:search_choices/search_choices.dart';

CollectionReference companiesCollection = FirebaseFirestore.instance.collection('companies');

class RankingScreen extends StatefulWidget {
  final String category;
  RankingScreen(this.category);
  @override
  _RankingScreenState createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  @override
  Widget build(BuildContext context) {
    print(widget.category);
    return Scaffold(
      body: ListView(
        children: [
          // SearchChoices.single(
          //   hint: 'Category',
          //   value: category,
          //   style: inputTextStyle.copyWith(color: Colors.white),
          //   menuBackgroundColor: Colors.blue,
          //   isExpanded: true,
          //   items: categories.map((e) => DropdownMenuItem(value: e, child: Text(e, style: inputTextStyle))).toList(),
          //   onChanged: (index) => setState(() => category = index),
          // ),
          FutureBuilder(
            future: getTopTen(),
            builder: (context, snapshot) => snapshot.connectionState != ConnectionState.done
                ? loader
                : snapshot.hasData && (snapshot.data as List<Widget>).length != 0
                    ? Container(
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: (snapshot.data as List<Widget>).length,
                          itemBuilder: (context, index) => (snapshot.data as List<Widget>)[index],
                          separatorBuilder: (context, index) => Divider(),
                        ),
                        decoration: backgroundDecoration,
                      )
                    : Container(),
          ),
        ],
      ),
    );
  }

  Future<List<Widget>> getTopTen() async {
    List<Widget> ret = [];
    await companiesCollection.where('industry', isEqualTo: widget.category).orderBy('totalScore').limit(10).get().then((value) {
      value.docs.forEach((element) {
        print(element.data());
        ret.add(
          ListTile(
            leading: Text((ret.length + 1).toString() + "."),
            title: Text(
              element.data()['name'],
            ),
            trailing: Text(element.data()['totalScore'].toString()),
          ),
        );
      });
    });
    print(ret);
    return ret;
  }
}
