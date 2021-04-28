import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rankless/Launch/uploader.dart';
import 'package:rankless/Survey/Survey.dart';
import 'package:rankless/shared/Interface.dart';

import 'Employee.dart';
import 'Post.dart';

class Company {
  bool triedImage = false;
  String uid;
  String name;
  String industry;
  NetworkImage image;
  String description;
  String country;
  List<Employee> employees = [];
  List<Post> posts = [];
  List<String> tags = [];
  List<String> positions = [];
  List<String> requests = [];
  List<Survey> surveys = [];
  List<Survey> publicSurveys = [];
  Employee me;
  double totalScore = 0.0;
  int surveysDone = 0;

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
      'totalScore': this.totalScore,
      'surveysDone': this.surveysDone,
    });
    this.uid = ref.id;
    return this;
  }

  Future updateCompany({
    String newDescription,
    Survey newSurvey,
    File newImage,
  }) async {
    if (newDescription != null) {
      this.description = newDescription;
      await companiesCollection.doc(this.uid).update({'description': this.description});
    }
    if (newSurvey != null) {
      this.surveys.add(newSurvey);
      await companiesCollection.doc(this.uid).update({'surveys': this.surveys.map((e) => e.uid).toList()});
    }
    if (newImage != null) {
      this.image = NetworkImage(await Uploader().uploadImage(newImage.path, this.uid + '2'));
    }
  }

  Stream<Company> get self {
    if (uid == null) return null;
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
    //this.surveysDone = ref['surveysDone'];
    //this.totalScore = ref['totalScore'];
    return this;
  }

  Future getEmployees(bool withImages) async {
    await Future.forEach(employees, (Employee e) async {
      await e.getEmployee(withImages);
    });
  }

  /// Accepts or Denies access to Company based on [accepted]
  Future handleRequest(bool accepted) async {
    String e = requests[0];
    String uidTemp = e.substring(0, e.indexOf('%'));

    await userCollection.doc(uidTemp).update({
      'request': (accepted ? "accepted" : 'denied') + '%' + this.name,
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
  }

  /// Updates position or tags or both.
  /// If [remove == true] then newTags will be removed from tags.
  ///
  /// Either [position] or [addTags] or [removeTags] should have value. Otherwise nothing will happen.
  Future addPositionOrTags(Employee who, {String position, List<String> addTags, List<String> removeTags}) async {
    if (position == null && addTags == null && removeTags != null) return;
    await getAllSurveys(false);
    List<String> allTags;
    allTags.addAll(who.tags);
    if (addTags != null) allTags.addAll(addTags);
    if (removeTags != null) allTags.removeWhere((element) => removeTags.contains(element));
    List<Survey> newSurveys = surveys
        .where((e) {
          if (position != null && e.tags.contains(position)) return true;
          if (allTags != null) for (String tag in allTags) if (e.tags.contains(tag)) return true;
          return false;
        })
        .where((e) => e.status == STATUS.Upcoming)
        .toList();
    who.surveys
      ..addAll(newSurveys)
      ..toSet()
      ..toList();
    await who.updateEmployee(newPosition: position, newTags: allTags, newSurveys: who.surveys);
  }

  ///Returns [List] of [surveys] without [results]
  Future<List<Survey>> getAllSurveys(bool withResults) async {
    await Future.wait(publicSurveys.map((e) async => await e.getSurvey(withResults)).toList());
    await Future.wait(surveys.map((e) async => await e.getSurvey(withResults)).toList());
    this.surveys.addAll(publicSurveys);
    return this.surveys;
  }

  Future<NetworkImage> getImage() async {
    if (triedImage) return this.image;
    triedImage = true;
    return this.image = NetworkImage(await Uploader().getImage(this.uid + '2'));
  }

  /// Puts newly selected [image] as profile picture for [company]
  Future changeImage() async {
    PickedFile image = await ImagePicker().getImage(source: ImageSource.gallery);
    if (image == null) return;
    File cropped = await ImageCropper.cropImage(sourcePath: image.path);
    await updateCompany(newImage: cropped ?? File(image.path));
  }
}
