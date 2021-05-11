import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rankless/Survey/Survey.dart';
import 'package:rankless/shared/Interface.dart';

import 'Employee.dart';

class Company {
  bool triedImage = false;
  String uid;
  String name;
  String industry;
  String country;
  List<Employee> employees = [];
  List<Employee> pending = [];
  List<String> tags = [];
  List<String> positions = [];
  List<String> requests = [];
  List<Survey> surveys = [];
  bool dummy;

  Company({
    this.uid,
    this.name,
    this.industry,
    this.employees,
    this.country,
    this.dummy = false,
  });

  Future createCompany() async {
    List<String> employeeUids = employees.map((e) => e.uid).toList();
    DocumentReference ref = companiesCollection.doc();
    await ref.set({
      'name': this.name,
      'industry': this.industry,
      'employees': employeeUids,
      'tags': <String>[],
      'country': this.country,
      'requests': <String>[],
      'surveys': <String>[],
      'positions': <String>[],
    });
    this.uid = ref.id;
    return this;
  }

  Future updateCompany({
    Survey newSurvey,
    String newPosition,
    bool addPosition = true,
    String newTag,
    bool addTag = true,
  }) async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      Map<String, dynamic> run = {};
      if (newSurvey != null) {
        this.surveys.add(newSurvey);
        run['surveys'] = this.surveys.map((e) => e.uid).toList();
      }
      if (newPosition != null) {
        if (addPosition)
          this.positions.add(newPosition);
        else
          this.positions.remove(newPosition);
        run['positions'] = this.positions;
      }
      if (newTag != null) {
        if (addTag)
          this.tags.add(newTag);
        else
          this.tags.remove(newTag);
        run['tags'] = this.tags;
      }
      transaction.update(companiesCollection.doc(this.uid), run);
    });
  }

  Stream<Company> get self {
    if (uid == null || dummy) return null;
    return companiesCollection.doc(this.uid).snapshots().map((event) => updateData(event));
  }

  Company updateData(DocumentSnapshot ref) {
    this.name = ref['name'];
    this.industry = ref['industry'];
    this.tags = List<String>.from(ref['tags'] as List<dynamic>) ?? [];
    this.country = ref['country'];
    this.requests = List<String>.from(ref['requests'] as List<dynamic>) ?? [];
    this.positions = List<String>.from(ref['positions'] as List<dynamic>);

    this.pending = (ref['pending'] as List<dynamic> ?? []).map((e) => e as String).toList().map((e) => Employee(uid: e)).toList();

    List<String> newEmployeesList = (ref['employees'] as List<dynamic>).map((e) => e as String).toList();
    if (this.employees == null || !isSublist(newEmployeesList, this.employees.map((e) => e.uid).toList()))
      this.employees = newEmployeesList.map((e) => Employee(uid: e)).toList();
    else
      this.employees.removeWhere((element) => !newEmployeesList.contains(element.uid));
    this.surveys = List<String>.from(ref['surveys'] as List<dynamic>).map((e) => Survey(uid: e)).toList();
    return this;
  }

  Future getEmployees() async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      if (this.pending != null && this.pending.length > 0) {
        this.employees.addAll(this.pending);
        transaction.update(companiesCollection.doc(this.uid), {'employees': this.employees});
      }
    }).whenComplete(() => Future.forEach(employees, (e) async {
          await e.getEmployee();
        }));
  }

  Future leaveCompany(Employee who) async {
    this.employees.remove(who);
    await who.leaveCompany(this);
  }

  /// Updates position or tags or both.
  ///
  /// Either [position] or [addTags] or [removeTags] should have value. Otherwise nothing will happen.
  Future addPositionOrTags(Employee who, {String position, List<String> addTags}) async {
    if (position == null && addTags == null) return;
    await who.updateEmployee(
      newPosition: position,
      newTags: addTags,
    );
  }

  ///Returns [List] of [surveys] without [results]
  /*Future<List<Survey>> getAllSurveys(bool withResults) async {
    return this.surveys = await Future.wait(surveys.map((e) async => await e.getSurvey(withResults)).toList());
  }*/

  /*Future<NetworkImage> getImage() async {
    if (triedImage || dummy) return this.image;
    triedImage = true;
    return this.image = NetworkImage(await Uploader().getImage(this.uid + '2'));
  }

  /// Puts newly selected [image] as profile picture for [company]
  Future changeImage() async {
    PickedFile image = await ImagePicker().getImage(source: ImageSource.gallery, imageQuality: 15);
    if (image == null) return;
    File cropped = await ImageCropper.cropImage(sourcePath: image.path);
    await updateCompany(newImage: cropped ?? File(image.path));
  }*/

  ///Checks if [a] is sublist of [b]
  bool isSublist(List<String> a, List<String> b) {
    a.sort();
    b.sort();
    bool ret = true;
    a.forEach((element) {
      if (!b.contains(element)) ret = false;
    });
    return ret;
  }
}
