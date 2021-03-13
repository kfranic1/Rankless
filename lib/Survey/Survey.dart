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
  DateTime from =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime to = DateTime(
      DateTime.now().year,
      DateTime.now().add(Duration(days: 7)).month,
      DateTime.now().add(Duration(days: 7)).day);
  STATUS status;
  Survey({this.uid, this.name, this.company}) {
    if (company != null)
      this.notFilled = company.employees.map((e) => e.uid).toList();
  }

  CollectionReference surveyCollection =
      FirebaseFirestore.instance.collection('surveys');

  CollectionReference resultCollection =
      FirebaseFirestore.instance.collection('results');

  Future createSurvey() async {
    DocumentReference ref = surveyCollection.doc();
    await ref.set({
      'name': this.name,
      'company': this.company.uid, //? ne cini se potrebno
      'filled': [],
      'question': qNa.map((e) => e.toMap()).toList(),
      'notfilled': this.notFilled,
      'from': this.from.toString(),
      'to': this.to.toString(),
    });
    this.uid = ref.id;
    await company.updateCompany(newSurvey: this.uid);
    await company.getEmployees();
    company.employees.forEach((employee) async {
      bool gets = this.tags.length == 0;
      for (String tag in tags) {
        if (employee.roles.contains(tag)) {
          gets = true;
          break;
        }
      }
      if (gets) {
        employee.surveys.add(this);
        await employee.updateEmployee(newSurveys: employee.surveys);
      }
    });
    return;
  }

  Future getSurvey() async {
    updateData(await surveyCollection.doc(this.uid).get());
  }

  Survey updateData(DocumentSnapshot ref) {
    this.name = ref['name'];
    this.from = DateTime.parse(ref['from']);
    this.to = DateTime.parse(ref['to']);
    dynamic questions = ref['question'];
    this.filled = List<String>.from(ref['filled'] as List<dynamic>) ?? [];
    this.notFilled = List<String>.from(ref['notfilled'] as List<dynamic>) ?? [];
    this.qNa = (questions as List<dynamic>)
        .map((e) => e as Map<String, dynamic>)
        .map((e) => Question().fromMap(e))
        .toList();
    this.status = getStatus();
    return this;
  }

  Future submitSurvey(Employee who) async {
    //! Who mora biti me iz streama inace nece radit
    who.surveys.remove(this);
    await who.updateEmployee(newSurveys: who.surveys);
  }

  STATUS getStatus() {
    if (this.to.isBefore(DateTime.now())) return STATUS.Past;
    if (this.from.isBefore(DateTime.now())) return STATUS.Active;
    return STATUS.Upcoming;
  }
}

enum STATUS { Active, Past, Upcoming }
