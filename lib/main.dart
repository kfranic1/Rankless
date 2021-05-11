import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:rankless/User/Employee.dart';
import 'package:rankless/Launch/auth.dart';
import 'package:rankless/Launch/wrapper.dart';
import 'package:rankless/shared/Interface.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
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
            updateShouldNotify: (previous, current) => previous != current,
            initialData: Employee(dummy: true),
            value: AuthService().employee,
            child: MaterialApp(
              theme: ThemeData(
                fontFamily: 'Muilsh',
                highlightColor: Colors.white,
              ),
              title: "Rankless",
              home: Wrapper(),
            ),
          );
        }
        return MaterialApp(theme: ThemeData(fontFamily: 'Mulish'), home: loader);
      },
    );
  }
}
