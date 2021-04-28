import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:rankless/User/Company.dart';
import 'package:rankless/shared/Interface.dart';
import 'CompanyPage.dart';

CollectionReference companiesCollection = FirebaseFirestore.instance.collection('companies');

class RankingScreen extends StatefulWidget {
  final String category;
  RankingScreen(this.category);
  @override
  _RankingScreenState createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  List<Company> popis = [];
  Future _future;

  @override
  void initState() {
    _future = getTopTen();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    print(widget.category);
    return Scaffold(
      body: ListView(
        children: [
          //TODO Mozda neki naslov na vrhu ime kategorije il nes
          FutureBuilder(
            future: _future,
            builder: (context, snapshot) => snapshot.connectionState != ConnectionState.done
                ? loader
                : popis.length > 0
                    ? Container(
                        child: ListView.separated(
                          shrinkWrap: true,
                          physics: ClampingScrollPhysics(),
                          itemCount: popis.length,
                          itemBuilder: (context, index) => ListTile(
                            leading: CircleAvatar(
                              foregroundImage: popis[index].image,
                            ), //Text((index + 1).toString() + "."),
                            title: Text(popis[index].name),
                            trailing: Text(popis[index].totalScore.toString()),
                            onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => CompanyPage(popis[index])),
                            ),
                          ),
                          separatorBuilder: (context, index) => Container(
                            //divider se nevidi bas
                            height: 20,
                            color: Colors.white,
                          ),
                        ),
                        decoration: backgroundDecoration,
                      )
                    : Container(),
          ),
        ],
      ),
    );
  }

  Future getTopTen() async {
    await companiesCollection.where('industry', isEqualTo: widget.category).orderBy('totalScore').limit(10).get().then((value) async {
      await Future.forEach(value.docs, ((QueryDocumentSnapshot element) async {
        popis.add(Company(uid: element.id).updateData(element));
        await popis.last.getImage();
      }));
    });
  }
}
