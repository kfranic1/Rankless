import 'package:firebase_auth/firebase_auth.dart';
import 'package:rankless/User/Employee.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  //Transform users to employees on changes
  Employee _employeeFromFirebase(User user, {name, surname}) {
    return user != null
        ? Employee(
            anonymus: user.isAnonymous,
            uid: user.uid,
            email: user.email,
            name: name,
            surname: surname,
          )
        : null;
  }

  Stream<Employee> get employee {
    return _auth.authStateChanges().map(_employeeFromFirebase);
  }

  Future signInAnonymus() async {
    try {
      return await _auth.signInAnonymously();
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future registerWithEmailAndPassword(
      String email, String password, String name, String surname) async {
    try {
      UserCredential result = await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
      await _employeeFromFirebase(result.user, name: name, surname: surname)
          .createEmployee();
      return;
    } on FirebaseAuthException catch (e) {
      return e.message;
    }
  }

  Future logInWithEmailAndPassword(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
          email: email, password: password);
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
