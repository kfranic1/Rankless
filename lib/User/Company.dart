import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rankless/Survey/Survey.dart';
import 'package:rankless/shared/Interface.dart';

import 'Employee.dart';

class Company {
  bool triedImage = false;
  String uid;
  String name;
  String industry;
  String description;
  String country;
  List<Employee> employees = [];
  List<String> tags = [];
  List<String> positions = [];
  List<String> requests = [];
  List<Survey> surveys = [];
  List<Survey> publicSurveys = [];
  bool dummy;

  Company({
    this.uid,
    this.name,
    this.industry,
    this.employees,
    this.description,
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
      'description': this.description,
      'tags': <String>[],
      'country': this.country,
      'requests': <String>[],
      'surveys': <String>[],
      'publicSurveys': <String>[],
      'positions': <String>[],
    });
    this.uid = ref.id;
    return this;
  }

  Future updateCompany({
    String newDescription,
    Survey newSurvey,
    String newPosition,
    bool addPosition = true,
    String newTag,
    bool addTag = true,
  }) async {
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      Map<String, dynamic> run = {};
      if (newDescription != null) {
        this.description = newDescription;
        run['description'] = this.description;
      }
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
    this.description = ref['description'];
    this.industry = ref['industry'];
    dynamic employeesFromFirebase = ref['employees'];
    this.tags = List<String>.from(ref['tags'] as List<dynamic>) ?? [];
    this.country = ref['country'];
    this.requests = List<String>.from(ref['requests'] as List<dynamic>) ?? [];
    this.positions = List<String>.from(ref['positions'] as List<dynamic>);
    this.employees = (employeesFromFirebase as List<dynamic>).map((e) => Employee(uid: e as String)).toList();
    this.surveys = List<String>.from(ref['surveys'] as List<dynamic>).map((e) => Survey(uid: e)).toList();
    this.publicSurveys = List<String>.from(ref['publicSurveys'] as List<dynamic>).map((e) => Survey(uid: e)).toList();
    return this;
  }

  Future getEmployees() async {
    await Future.forEach(employees, (Employee e) async {
      await e.getEmployee();
    });
  }
  /*
  /// Accepts or Denies access to Company based on [accepted]
  ///
  /// Pass [position] and/or [tags] only when [accepted == true]
  Future handleRequest(bool accepted, {String position = '', List<String> tags = const []}) async {
    String e = requests[0];
    String uidTemp = e.substring(0, e.indexOf('%'));

    await userCollection.doc(uidTemp).update({
      'position': position,
      'tags': tags,
      'request': accepted ? '' : 'denied',
      'companyUid': accepted ? this.uid : null,
    });
    await FirebaseFirestore.instance.runTransaction((transaction) async {
      this.requests.removeAt(0);
      List<String> employeesTemp = this.employees.map((e) => e.uid).toList();
      if (accepted) employeesTemp.add(uidTemp);
      transaction.update(companiesCollection.doc(this.uid), {
        'requests': this.requests,
        'employees': employeesTemp,
      });
    });
  }*/

  /// Updates position or tags or both.
  /// If [remove == true] then newTags will be removed from tags.
  ///
  /// Either [position] or [addTags] or [removeTags] should have value. Otherwise nothing will happen.
  Future addPositionOrTags(Employee who, {String position, List<String> addTags}) async {
    if (position == null && addTags == null) return;
    //await getAllSurveys(false);
    if (addTags != null) who.tags = addTags;
    if (position != null) who.position = position;

    //TODO provjera surveya

    // List<Survey> newSurveys = surveys
    //     .where((e) {
    //       if (position != null && e.tags.contains(position)) return true;
    //       if (allTags != null) for (String tag in allTags) if (e.tags.contains(tag)) return true;
    //       return false;
    //     })
    //     .where((e) => e.status == STATUS.Upcoming)
    //     .toList();
    // who.surveys
    //   ..addAll(newSurveys)
    //   ..toSet()
    //   ..toList();

    await who.updateEmployee(newPosition: who.position, newTags: who.tags, newSurveys: who.surveys);
  }

  ///Returns [List] of [surveys] without [results]
  Future<List<Survey>> getAllSurveys(bool withResults) async {
    await Future.wait(publicSurveys.map((e) async => await e.getSurvey(withResults)).toList())
        .whenComplete(() async => await Future.wait(surveys.map((e) async => await e.getSurvey(withResults)).toList()));
    this.surveys.addAll(publicSurveys);
    return this.surveys;
  }

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
}
