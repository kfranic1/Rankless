import 'package:firebase_auth/firebase_auth.dart';
import 'package:rankless/Employee.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Transform users to employees on changes
  Employee _employeeFromFirebase(User user) {
    return user != null
        ? Employee(
            user.isAnonymous,
            uid: user.uid,
            email: user.email,
          )
        : null;
  }

  Stream<Employee> get employee {
    return _auth.authStateChanges().map(_employeeFromFirebase);
  }

  Future signInAnonymus() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      User user = result.user;
      return _employeeFromFirebase(user);
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future registerWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _employeeFromFirebase(user);
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future logInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(
          email: email, password: password);
      User user = result.user;
      return _employeeFromFirebase(user);
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future signOut() async {
    try {
      return await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }
}
