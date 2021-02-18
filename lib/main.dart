import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rankless/Employee.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(AppStarter());
}

class AppStarter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Rankless",
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  final Future<FirebaseApp> firebaseApp = Firebase.initializeApp();

  //FirebaseFirestore firestore = FirebaseFirestore.instance;
  final String title;
  MyHomePage({Key key, this.title}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState(firebaseApp);
}

class _MyHomePageState extends State<MyHomePage> {
  Future<FirebaseApp> firebaseApp;
  int _currentIndex = 0;
  PageController _pageController = new PageController();
  Widget body;
  //DatabaseReference referenceDatabase = FirebaseDatabase.instance.reference();

  _MyHomePageState(this.firebaseApp) {
    body = Center(child: CircularProgressIndicator());
    firebaseApp.whenComplete(() => setState(() {
          body = null;
        }));
  }

  void _onTap(int index) {
    bool animate = true;
    setState(
      () {
        if ((index - _currentIndex).abs() > 1) animate = false;
        _currentIndex = index;
      },
    );
    if (animate) {
      _pageController.animateToPage(
        index,
        duration: Duration(milliseconds: 200),
        curve: Curves.easeIn,
      );
    } else {
      _pageController.jumpToPage(
        index,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: Icon(Icons.circle),
        title: Text("Rankless"),
      ),
      body: body != null
          ? body
          : PageView(
              controller: _pageController,
              children: [
                Center(
                  child: Text("1"),
                ),
                Center(
                  child: RaisedButton(
                    onPressed: () {
                      Employee ante = new Employee("Ante", "Antic");
                      ante.createData();
                    },
                  ),
                ),
                Center(
                  child: Text("3"),
                ),
              ],
              onPageChanged: (int index) {
                _onTap(index);
              },
            ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        type: BottomNavigationBarType.fixed,
        onTap: _onTap,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.account_balance_outlined),
            label: "Company",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.toc_rounded),
            label: "Ranking",
          ),
        ],
      ),
    );
  }
}
