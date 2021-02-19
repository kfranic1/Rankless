import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rankless/Company.dart';

class Employee {
  bool anonymus;
  String uid;
  String name;
  String surname;
  Company company;
  String email;
  List<String> roles;
  //List<Komentar> comments;
  //List<Survey> surveys;

  Employee(this.anonymus,
      {this.uid, this.name, this.surname, this.email, this.roles});
}
