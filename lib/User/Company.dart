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
  List<Employee> employees = List<Employee>();
  //List<Survey> surveys;
  List<Post> posts = List<Post>();
  List<String> roles = List<String>();
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
    this.country = ref['country'];
    if (this.employees != null)
      this.employees.map((e) => Employee(uid: e as String)).toList();
    return this;
  }

  Future getEmployees() async {
    for (Employee e in employees) await e.getEmployee();
  }
}
