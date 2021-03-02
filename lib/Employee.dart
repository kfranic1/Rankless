import 'package:cloud_firestore/cloud_firestore.dart';

class Employee {
  bool anonymus;
  String uid;
  String name;
  String surname;
  String companyUid;
  String email;
  List<String> roles = List<String>();
  List<String> pendingSurveys = [];
  //List<Komentar> comments;

  CollectionReference userCollection =
      FirebaseFirestore.instance.collection('users');

  Employee({
    this.anonymus,
    this.uid,
    this.name,
    this.surname,
    this.email,
    this.roles,
  });

  Future createEmployee() async {
    return await userCollection.doc(this.uid).set({
      'name': this.name,
      'surname': this.surname,
      'email': this.email,
      'companyUid': null,
      'roles': this.roles,
      'surveys': this.pendingSurveys,
    });
  }

  Future updateEmployee({newName, newSurname, newRoles, newCompanyUid}) async {
    if (newName != null) this.name = newName;
    if (newSurname != null) this.surname = newSurname;
    if (newRoles != null) this.roles = newRoles;
    if (newCompanyUid != null) this.companyUid = newCompanyUid;
    return await userCollection.doc(this.uid).set({
      'name': this.name,
      'surname': this.surname,
      'roles': this.roles,
      'companyUid': this.companyUid,
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
    print('called');
    this.name = ref.data()['name'];
    this.surname = ref.data()['surname'];
    this.email = ref.data()['email'];
    this.companyUid = ref.data()['companyUid'];
    this.roles = List<String>.from(ref.data()['roles']);
    this.pendingSurveys = List<String>.from(ref.data()['surveys']);
    return this;
  }
}
