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
  String request = '';
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
      'request': '',
    });
  }

  Future updateEmployee(
      {newName, newSurname, newRoles, newCompanyUid, newRequest}) async {
    if (newName != null) {
      this.name = newName;
      await userCollection.doc(this.uid).update({'name': this.name});
    }
    if (newSurname != null) {
      this.surname = newSurname;
      await userCollection.doc(this.uid).update({'surname': this.surname});
    }
    if (newRoles != null) {
      this.roles = newRoles;
      await userCollection.doc(this.uid).update({'roles': this.roles});
    }
    if (newCompanyUid != null) {
      this.companyUid = newCompanyUid;
      await userCollection
          .doc(this.uid)
          .update({'companyUid': this.companyUid});
    }
    if (newRequest != null) {
      this.request = newRequest;
      await userCollection.doc(this.uid).update({'request': this.request});
    }
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
    this.request = ref.data()['request'];
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
      req.add(this.uid);
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
}
