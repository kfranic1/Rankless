import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rankless/Company.dart';

class Employee {
  String name;
  String lastname;
  Company company;
  String email;
  List<String> roles;
  //List<Komentar> comments;
  //List<Survey> surveys;

  Employee(this.name, this.lastname, {this.roles});

  Future<void> createData() async {
    CollectionReference users = FirebaseFirestore.instance.collection('users');
    return users
        .add({
          'email': "a",
          'name': name,
          'lastname': lastname,
        })
        .then((value) => print("User added"))
        .catchError((error) => print("Error $error"));
  }

  Future<void> getData() async {}

  Future<void> updateData() async {}
}
