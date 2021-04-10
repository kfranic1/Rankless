import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';
import 'package:rankless/User/Employee.dart';
import 'package:rankless/Launch/auth.dart';
import 'package:rankless/Launch/wrapper.dart';
import 'package:rankless/shared/Interface.dart';

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
            updateShouldNotify: (previous, current) => true,
            initialData: null,
            value: AuthService().employee,
            child: MaterialApp(
              //locale: DevicePreview.locale(context), // Add the locale here
              //builder: DevicePreview.appBuilder, // Add the builder here

              theme: ThemeData(
                fontFamily: 'Muilsh',
                highlightColor: Colors.white,
              ),
              title: "Rankless",
              home: Wrapper(),
            ),
          );
        }
        return MaterialApp(
          theme: ThemeData(fontFamily: 'Mulish'),
          home: Scaffold(
            body: Center(child: loader),
          ),
        );
      },
    );
  }
}
