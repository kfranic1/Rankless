import 'package:rankless/Company.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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

  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Employee(this.anonymus,
      {this.uid, this.name, this.surname, this.email, this.roles});

  Future createEmployee() async {
    return await userCollection.doc(this.uid).set({
      'name': this.name,
      'surname': this.surname,
      'email': this.email,
      'company': null,
      'roles': null,
    });
  }

  //Update name and surname only
  Future updateEmployee({newName, newSurname}) async {
    if (newName != null) this.name = newName;
    if (newSurname != null) this.surname = newSurname;
    return await userCollection.doc(this.uid).set({
      'name': this.name,
      'surname': this.surname,
    });
  }

  Future getEmployee() async {
    updateData(await userCollection.doc(this.uid).get());
  }

  //will be used for updating users
  Stream<QuerySnapshot> get users {
    return userCollection.snapshots();
  }

  Stream<Employee> get self {
    return userCollection
        .doc(this.uid)
        .snapshots()
        .map((event) => updateData(event));
  }

  Employee updateData(DocumentSnapshot ref) {
    this.name = ref.data()['name'];
    this.surname = ref.data()['name'];
    this.email = ref.data()['email'];
    this.company = ref.data()['company'];
    this.roles = ref.data()['roles'] as List<String>;
    return this;
  }
}
