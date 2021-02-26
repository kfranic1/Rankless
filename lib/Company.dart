import 'package:cloud_firestore/cloud_firestore.dart';

import 'Employee.dart';
import 'Post.dart';

class Company {
  String uid;
  String name;
  String industry;
  //SLIKA
  String description;
  List<Employee> employees;
  //List<Survey> surveys;
  List<Post> posts;

  CollectionReference companiesCollection =
      FirebaseFirestore.instance.collection('companies');

  Company(
      {this.uid, this.name, this.industry, this.employees, this.description});

  Future createCompany() async {
    List<String> employeeUids = employees.map((e) => e.uid).toList();
    DocumentReference ref = companiesCollection.doc();
    await ref.set({
      'name': this.name,
      'industry': this.industry,
      'employees': employeeUids,
      'description': this.description,
    }).then((value) => print('done'));
    this.uid = ref.id;
    return this;
  }

  Future getData() async {
    updateData(await companiesCollection.doc(this.uid).get());
    if (this.employees == null) await getEmployees();
  }

  Future<void> changeData() async {}

  Stream<Company> get self {
    return companiesCollection
        .doc(this.uid)
        .snapshots()
        .map((event) => updateData(event));
  }

  Company updateData(DocumentSnapshot ref) {
    this.name = ref['name'];
    this.description = ref['description'];
    this.industry = ref['industry'];
    this.employees = (ref['employees'] as List<dynamic>)
        .map((e) => Employee(uid: e as String))
        .toList();
    return this;
  }

  Future getEmployees() async {
    if (this.employees == null) return;
    for (Employee e in employees) await e.getEmployee();
  }
}
