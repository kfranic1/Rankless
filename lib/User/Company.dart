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
