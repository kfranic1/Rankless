import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:rankless/Employee.dart';
import 'package:rankless/auth.dart';
import 'package:rankless/wrapper.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(AppStarter());
}

class AppStarter extends StatelessWidget {
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
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
