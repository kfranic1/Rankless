import 'package:flutter/material.dart';
import 'package:rankless/User/Company.dart';
import 'package:rankless/shared/Interface.dart';
import 'package:rankless/shared/custom_app_bar.dart';

class CompanyPage extends StatefulWidget {
  final Company company;
  CompanyPage(this.company);
  @override
  _CompanyPageState createState() => _CompanyPageState();
}

class _CompanyPageState extends State<CompanyPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        show: false,
      ),
      body: Container(
        padding: EdgeInsets.all(10),
        width: double.infinity,
        height: double.infinity,
        decoration: backgroundDecoration,
        child: ListView(
          shrinkWrap: true,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 50,
                  foregroundImage: widget.company.image,
                ),
                SizedBox(
                  width: 60,
                ),
                Text(
                  widget.company.name,
                  style: titleNameStyle,
                )
              ],
            ),
            Row(
              children: [
                Expanded(
                    flex: 3,
                    child: Container(
                      child: ListTile(
                        leading: Icon(
                          Icons.list,
                          color: Colors.white,
                          size: 50,
                        ),
                        title: Text(
                          widget.company.industry,
                          style: TextStyle(color: Colors.white, fontFamily: font, fontSize: 22),
                        ),
                      ),
                    )),
                Expanded(
                  flex: 2,
                  child: Container(
                    //padding: EdgeInsets.only(left: 70),
                    child: ListTile(
                      leading: Icon(
                        Icons.format_list_numbered_rounded,
                        color: Colors.white,
                        size: 50,
                      ),
                      title: Text(
                        '#',
                        style: TextStyle(color: Colors.white, fontFamily: font, fontSize: 22),
                      ), //ovdje ide pozicija na rankingu
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            SizedBox(
              height: 50,
            ),
            widget.company.surveys.length == 0
                ? Center(
                    child: Text(
                      "You don't have any completed surveys",
                      style: TextStyle(fontFamily: font, fontSize: 20, color: Colors.white),
                    ),
                  )
                : Container(
                    margin: EdgeInsets.only(left: 20),
                    child: Text(
                      "Survey results:",
                      style: TextStyle(fontFamily: font, fontSize: 20, color: Colors.white),
                    ),
                  ),
            SizedBox(
              height: 30,
            ),
            widget.company.publicSurveys.length == 0
                ? Text("This company has no public surveys available")
                //TODO zasad svaki survey mozes pogleat pojedinacno
                : FutureBuilder(
                    future: widget.company.getAllSurveys(true),
                    builder: (context, snapshot) {
                      return snapshot.connectionState != ConnectionState.done
                          ? loader
                          : Container(
                              /*height: 80,
                              child: ListView.separated(
                                  scrollDirection: Axis.horizontal,
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) => filledSurveys(widget.company.publicSurveys[index], context),
                                  separatorBuilder: (context, index) => SizedBox(width: 20),
                                  itemCount: widget.company.publicSurveys.length),*/
                            );
                    }),
          ],
        ),
      ),
    );
  }
}
