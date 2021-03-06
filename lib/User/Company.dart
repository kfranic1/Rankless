import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'Employee.dart';
import 'Post.dart';

class Company {
  String uid;
  String name;
  String industry;
  //SLIKA
  String description;
  String country;
  List<Employee> employees = [];
  //List<Survey> surveys;
  List<Post> posts = [];
  List<String> roles = [];
  List<String> requests = [];
  Employee me;

  CollectionReference companiesCollection =
      FirebaseFirestore.instance.collection('companies');

  Company({
    this.uid,
    this.name,
    this.industry,
    this.employees,
    this.description,
    this.me,
    this.country,
  });

  Future createCompany() async {
    this.roles.add('admin');
    List<String> employeeUids = employees.map((e) => e.uid).toList();
    DocumentReference ref = companiesCollection.doc();
    await ref.set({
      'name': this.name,
      'industry': this.industry,
      'employees': employeeUids,
      'description': this.description,
      'roles': this.roles,
      'country': this.country,
      'requests': this.requests,
    }).then((value) => print('done'));
    this.uid = ref.id;
    return this;
  }

  Future<Company> getData() async {
    updateData(await companiesCollection.doc(this.uid).get());
    await getEmployees();
    return this;
  }

  Future<void> changeData() async {}

  Stream<Company> get self {
    if (uid == null) return null;
    return companiesCollection
        .doc(this.uid)
        .snapshots()
        .map((event) => updateData(event));
  }

  Company updateData(DocumentSnapshot ref) {
    this.name = ref['name'];
    this.description = ref['description'];
    this.industry = ref['industry'];
    dynamic employeesFromFirebase = ref['employees'];
    this.roles = List<String>.from(ref['roles'] as List<dynamic>) ?? [];
    this.country = ref['country'];
    this.requests = List<String>.from(ref['requests'] as List<dynamic>) ?? [];
    this.employees = (employeesFromFirebase as List<dynamic>)
        .map((e) => Employee(uid: e as String))
        .toList();
    return this;
  }

  Future getEmployees() async {
    for (Employee e in employees) await e.getEmployee();
  }

  Text getRequestAsText() {
    String e = requests[0];
    String nameTemp = e.substring(e.indexOf('%') + 1, e.lastIndexOf('%'));
    String surnameTemp = e.substring(e.lastIndexOf('%') + 1);
    return Text(
        nameTemp + ' ' + surnameTemp + ' has requested to join your company');
  }

  void handleRequest(bool accpeted) async {
    String e = requests[0];
    String uidTemp = e.substring(0, e.indexOf('%'));

    await FirebaseFirestore.instance.collection('users').doc(uidTemp).update({
      'request': (accpeted ? "accepted" : 'denied') + '%' + this.name,
      'companyUid': this.uid,
    });
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      this.requests.removeAt(0);
      List<String> employeesTemp = this.employees.map((e) => e.uid).toList();
      employeesTemp.add(uidTemp);
      transaction.update(companiesCollection.doc(this.uid), {
        'requests': this.requests,
        'employees': employeesTemp,
      });
    });
  }

  Widget getRequestsAsWidget() {
    print('here' + this.requests.toString());
    if (this.requests == null || this.requests.length == 0)
      return Text("There are no requests");
    List<Employee> req = this
        .requests
        .map((e) => Employee(
              uid: e.substring(
                0,
                e.indexOf('%'),
              ),
              name: e.substring(e.indexOf('%') + 1, e.lastIndexOf('%')),
              surname: e.substring(e.lastIndexOf('%') + 1),
            ))
        .toList();
    return SizedBox(
      height: 500,
      child: ListView(
        children: req
            .map(
              (e) => SizedBox(
                height: 100,
                child: Card(
                  color: Colors.blue[100],
                  child: Column(
                    children: [
                      Expanded(
                        child: Text(e.name +
                            ' ' +
                            e.surname +
                            ' has requested to join your company.'),
                      ),
                      Expanded(
                        child: Row(
                          children: [
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  color: Colors.green,
                                  child: TextButton(
                                    child: Text('Allow'),
                                    onPressed: () {},
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Container(
                                  color: Colors.red,
                                  child: TextButton(
                                    child: Text('Deny'),
                                    onPressed: () {},
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
