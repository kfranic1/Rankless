import 'package:cloud_firestore/cloud_firestore.dart';

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
  List<String> tags = [];
  List<String> positions = [];
  List<String> requests = [];
  List<String> surveys = [];
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
    List<String> employeeUids = employees.map((e) => e.uid).toList();
    DocumentReference ref = companiesCollection.doc();
    await ref.set({
      'name': this.name,
      'industry': this.industry,
      'employees': employeeUids,
      'description': this.description,
      'tags': this.tags,
      'country': this.country,
      'requests': this.requests,
      'surveys': this.surveys,
      'positions': this.positions,
    });
    this.uid = ref.id;
    return this;
  }

  Future updateCompany({
    newDescription,
    newSurvey,
  }) async {
    if (newDescription != null) {
      this.description = newDescription;
      await companiesCollection
          .doc(this.uid)
          .update({'description': this.description});
    }
    if (newSurvey != null) {
      this.surveys.add(newSurvey);
      await companiesCollection.doc(this.uid).update({'surveys': this.surveys});
    }
  }

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
    this.tags = List<String>.from(ref['tags'] as List<dynamic>) ?? [];
    this.country = ref['country'];
    this.requests = List<String>.from(ref['requests'] as List<dynamic>) ?? [];
    this.positions = List<String>.from(ref['positions'] as List<dynamic>);
    this.employees = (employeesFromFirebase as List<dynamic>)
        .map((e) => Employee(uid: e as String))
        .toList();
    this.surveys = List<String>.from(ref['surveys'] as List<dynamic>);
    return this;
  }

  Future getEmployees() async {
    for (Employee e in employees) await e.getEmployee();
  }

  Future surveyDone() async {}

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
}
