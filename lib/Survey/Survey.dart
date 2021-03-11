import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rankless/User/Company.dart';
import 'package:rankless/User/Employee.dart';

import 'Question.dart';

class Survey {
  Company company;
  String uid;
  String name;
  List<Question> qNa = [];
  List<String> filled;
  List<String> notFilled;
  List<String> tags = [];
  List<String> answers = []; //to je lista odgovora pojedinacne osobe
  DateTime from;
  DateTime to;
  Survey(this.name, this.company) {
    this.notFilled = company.employees.map((e) => e.uid).toList();
  }

  CollectionReference surveyCollection =
      FirebaseFirestore.instance.collection('surveys');

  Future createSurvey() async {
    DocumentReference ref = surveyCollection.doc();
    await ref.set({
      'name': this.name,
      'company': this.company.uid,
      'filled': [],
      'question': qNa.map((e) => e.toMap()).toList(),
      'notfilled': this.notFilled,
      'from': this.from..toString(),
      'to': this.to.toString(),
    });
    //TODO dodavanje surveya u bazu od kompanije
    this.uid = ref.id;
  }

  Future getSurvey() async {
    updateData(await surveyCollection.doc(this.uid).get());
  }

  Survey updateData(DocumentSnapshot ref) {
    this.name = ref['name'];
    this.from = DateTime.parse(ref['from']);
    this.to = DateTime.parse(ref['to']);
    dynamic questions = ref['qNa'];
    this.filled = List<String>.from(ref['filled'] as List<dynamic>) ?? [];
    this.notFilled = List<String>.from(ref['notfilled'] as List<dynamic>) ?? [];
    this.qNa = (questions as List<dynamic>)
        .map((e) => e as Map<String, dynamic>)
        .map((e) => Question().fromMap(e))
        .toList();
    return this;
  }

  Future submitSurvey(Employee who) async {
    //TODO Who mora biti me iz streama inace nece radit
    who.pendingSurveys.remove(this.uid);
    await who.updateEmployee(newSurveys: who.pendingSurveys);
  }
}
