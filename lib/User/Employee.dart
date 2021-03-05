import 'package:cloud_firestore/cloud_firestore.dart';

class Employee {
  bool anonymus;
  String uid;
  String name;
  String surname;
  String companyUid;
  String email;
  List<String> roles = [];
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
      'request': this.request,
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

  Stream<Employee> get self {
    return userCollection
        .doc(this.uid)
        .snapshots()
        .map((event) => updateData(event));
  }

  Employee updateData(DocumentSnapshot ref) {
    //print('called');
    this.name = ref['name'];
    this.surname = ref['surname'];
    this.email = ref['email'];
    this.companyUid = ref['companyUid'];
    this.roles = List<String>.from(ref['roles'] as List<dynamic>);
    this.pendingSurveys = List<String>.from(ref['surveys'] as List<dynamic>);
    this.request = ref['request'];
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
}
