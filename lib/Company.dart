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
  List<String> roles;
  Employee me;

  CollectionReference companiesCollection =
      FirebaseFirestore.instance.collection('companies');

  Company(
      {this.uid,
      this.name,
      this.industry,
      this.employees,
      this.description,
      this.me});

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
    return companiesCollection
        .doc(this.uid)
        .snapshots()
        .map((event) => updateData(event));
  }

  Company updateData(DocumentSnapshot ref) {
    this.name = ref['name'];
    this.description = ref['description'];
    this.industry = ref['industry'];
    this.employees = (ref['employees'] as List<dynamic>);
    if (this.employees != null)
      this.employees.map((e) => Employee(uid: e as String)).toList();
    return this;
  }

  Future getEmployees() async {
    for (Employee e in employees) if (e.uid != me.uid) await e.getEmployee();
  }
}
