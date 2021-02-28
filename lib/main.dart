import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:rankless/Employee.dart';
import 'package:rankless/SurveyUI.dart';
import 'package:rankless/auth.dart';
import 'package:rankless/wrapper.dart';

import 'Survey.dart';
import 'testing.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(AppStarter());
}

Survey survey = Survey("Survey");

class AppStarter extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

//#region testiranje
  //ako zelite testirat nesto samo u test stavite true i u testing ime widgeta kojeg testirate

  final bool test = false;
  final Widget testing = SurveyUI(survey);
//#endregion
  @override
  Widget build(BuildContext context) {
    return test
        ? Testing(testing)
        : FutureBuilder(
            future: _initialization,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text("Something went wrong"),
                );
              }
              if (snapshot.connectionState == ConnectionState.done) {
                return StreamProvider<Employee>.value(
                  value: AuthService().employee,
                  child: MaterialApp(
                    title: "Rankless",
                    home: Wrapper(),
                  ),
                );
              }
              return MaterialApp(
                theme: ThemeData(
                  fontFamily: 'Mulish',
                ),
                home: Scaffold(
                  body: Center(
                    //TODO swap with custom loader
                    child: CircularProgressIndicator(),
                  ),
                ),
              );
            },
          );
  }
}
