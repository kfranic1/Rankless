import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:rankless/Company.dart';

class Employee {
  String uid;
  String name;
  String lastname;
  Company company;
  String email;
  List<String> roles;
  //List<Komentar> comments;
  //List<Survey> surveys;

  Employee({this.uid, this.name, this.lastname, this.email, this.roles});
}
