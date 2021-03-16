import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rankless/Survey/Survey.dart';

class Employee {
  bool anonymus;
  String uid;
  String name;
  String surname;
  String companyUid;
  String email;
  String position = '';
  String request = '';
  bool admin = false;
  List<String> tags = [];
  List<Survey> surveys = [];
  //List<Komentar> comments;
  //TODO: Add error support

  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Employee({
    this.anonymus,
    this.uid,
    this.name,
    this.surname,
    this.email,
  });

  Future createEmployee() async {
    return await userCollection.doc(this.uid).set({
      'name': this.name,
      'surname': this.surname,
      'email': this.email,
      'companyUid': null,
      'tags': <String>[],
      'surveys': <String>[],
      'request': this.request,
      'admin': this.admin,
      'position': this.position,
    });
  }

  Future updateEmployee(
      {String newName,
      String newSurname,
      List<String> newTags,
      String newCompanyUid,
      String newRequest,
      List<Survey> newSurveys,
      bool newAdmin,
      String newPosition}) async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      Map<String, dynamic> run = {};
      if (newName != null) {
        this.name = newName;
        run['name'] = this.name;
      }
      if (newSurname != null) {
        this.surname = newSurname;
        run['surname'] = this.surname;
      }
      if (newTags != null) {
        this.tags = newTags;
        run['tags'] = this.tags;
      }
      if (newCompanyUid != null) {
        this.companyUid = newCompanyUid;
        run['companyUid'] = this.companyUid;
      }
      if (newRequest != null) {
        this.request = newRequest;
        run['request'] = this.request;
      }
      if (newSurveys != null) {
        this.surveys = newSurveys;
        run['surveys'] = this.surveys.map((e) => e.uid).toList();
      }
      if (newAdmin != null) {
        this.admin = newAdmin;
        run['admin'] = this.admin;
      }
      if (newPosition != null) {
        this.position = newPosition;
        run['position'] = this.position;
      }
      transaction.update(userCollection.doc(this.uid), run);
    });
  }

  Future getEmployee() async {
    updateData(await userCollection.doc(this.uid).get());
    await handleSurveys();
  }

  Stream<Employee> get self {
    return userCollection
        .doc(this.uid)
        .snapshots()
        .map((event) => updateData(event));
  }

  Employee updateData(DocumentSnapshot ref) {
    this.name = ref['name'];
    this.surname = ref['surname'];
    this.email = ref['email'];
    this.companyUid = ref['companyUid'];
    this.tags = List<String>.from(ref['tags'] as List<dynamic>);
    this.surveys = List<String>.from(ref['surveys'] as List<dynamic>)
        .map((e) => Survey(uid: e))
        .toList();
    this.request = ref['request'];
    this.admin = ref['admin'];
    this.position = ref['position'];
    this.surveys.sort((a, b) => a.from.compareTo(b.from));
    return this;
  }

  Future sendRequestToCompany(
      String futureCompanyName, String futureCompanyUid) async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      print(futureCompanyName + ' ' + futureCompanyUid);
      DocumentReference ref = FirebaseFirestore.instance
          .collection('companies')
          .doc(futureCompanyUid);
      List<String> req = ((await ref.get())['requests'] as List)
          .map((e) => e.toString())
          .toList();
      req.add(this.uid + '%' + this.name + '%' + this.surname);
      transaction.update(ref, {
        'requests': req,
      });
    });
    await updateEmployee(
        newRequest: futureCompanyUid + '%' + futureCompanyName);
  }

  Future cancelRequestToCompany() async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      DocumentReference ref = FirebaseFirestore.instance
          .collection('companies')
          .doc(this.request.substring(0, this.request.indexOf('%')));
      List<String> req = ((await ref.get())['requests'] as List)
          .map((e) => e.toString())
          .toList();
      req.remove(this.uid);
      transaction.update(ref, {
        'requests': req,
      });
    });
    await updateEmployee(newRequest: '');
  }

  Future handleSurveys() async {
    await Future.wait(
        this.surveys.map((e) async => await e.getSurvey(false)).toList());
    List<String> past = [];
    for (Survey s in surveys) {
      if (s.status == STATUS.Past) {
        past.add(s.uid);
      }
    }
    if (past.length == 0) return;
    this.surveys.removeWhere((element) => past.contains(element));
    await updateEmployee(newSurveys: this.surveys);
  }
}
