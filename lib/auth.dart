import 'package:firebase_auth/firebase_auth.dart';
import 'package:rankless/Employee.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Transform users to employees on changes
  Employee _employeeFromFirebase(User user) {
    return user != null
        ? Employee(
            uid: user.uid,
            name: user.isAnonymous ? "anonymus" : user.displayName)
        : null;
  }

  Stream<Employee> get employee {
    return _auth.authStateChanges().map(_employeeFromFirebase);
  }

  Future signInAnonymus() async {
    try {
      UserCredential user = await _auth.signInAnonymously();
      return _employeeFromFirebase(user.user);
    } catch (e) {
      print(e.toString());
      return null;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } catch (e) {
      print(e.toString());
      return null;
    }
  }
}
