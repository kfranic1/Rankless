import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rankless/User/Company.dart';
import 'package:rankless/User/Employee.dart';

import 'Question.dart';

class Survey {
  Company company;
  String uid;
  String name;
  List<Question> qNa = [];
  List<String> tags = [];
  DateTime from =
      DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime to = DateTime(
      DateTime.now().year,
      DateTime.now().add(Duration(days: 7)).month,
      DateTime.now().add(Duration(days: 7)).day);
  STATUS status;
  Map<String, Map<int, List<String>>> results =
      new Map<String, Map<int, List<String>>>();

  Survey({this.uid, this.name, this.company});

  CollectionReference surveyCollection =
      FirebaseFirestore.instance.collection('surveys');

  CollectionReference resultCollection =
      FirebaseFirestore.instance.collection('results');

  Future createSurvey() async {
    DocumentReference ref = surveyCollection.doc();
    await ref.set({
      'name': this.name,
      'question': qNa.map((e) => e.toMap()).toList(),
      'from': this.from.toString(),
      'to': this.to.toString(),
      'tags': this.tags,
    });
    this.uid = ref.id;
    await company.updateCompany(newSurvey: this.uid);
    await company.getEmployees();
    await Future.forEach(
      company.employees,
      (Employee employee) async {
        bool gets = this.tags.length == 0;
        for (String tag in tags) {
          if (employee.tags.contains(tag) || employee.position == tag) {
            print(employee.name);
            gets = true;
            break;
          }
        }
        if (gets) {
          employee.surveys.add(this);
          await employee.updateEmployee(newSurveys: employee.surveys);
        }
      },
    );
  }

  int getCountBasedOnTags() {
    if (this.tags.length == 0) return this.company.employees.length;
    int ret = 0;
    company.employees.forEach((employee) async {
      for (String tag in tags) {
        if (employee.tags.contains(tag) || employee.position == tag) {
          ret++;
          break;
        }
      }
    });
    return ret;
  }

  Future<Survey> getSurvey(bool withResults) async {
    updateData(await surveyCollection.doc(this.uid).get());
    if (withResults) await _getResults();
    return this;
  }

  Survey updateData(DocumentSnapshot ref) {
    this.name = ref['name'];
    this.from = DateTime.parse(ref['from']);
    this.to = DateTime.parse(ref['to']);
    dynamic questions = ref['question'];
    this.qNa = (questions as List<dynamic>)
        .map((e) => e as Map<String, dynamic>)
        .map((e) => Question().fromMap(e))
        .toList();
    this.tags = List<String>.from(ref['tags'] as List<dynamic>);
    this.status = _getStatus();
    return this;
  }

  Future submitSurvey(Employee who) async {
    //! Who mora biti me iz streama inace nece radit
    who.surveys.remove(this);
    await who.updateEmployee(newSurveys: who.surveys);
    await resultCollection.doc(this.uid).set({
      who.uid: {
        'pos': who.position,
        'ans': qNa.map((e) {
          if (e.answerType == TYPE.Text) return e.singleAnswer;
          return e.mask.toString();
        }).toList()
      }
    });
  }

  Future _getResults() async {
    DocumentSnapshot data = await resultCollection.doc(this.uid).get();
    if (!data.exists) return;
    data.data().forEach((key, value) {
      String pos = value['pos'];
      if (this.results[pos] == null)
        this.results[pos] = new Map<int, List<String>>();
      List<String> ans = List<String>.from(value['ans'] as List<dynamic>);
      for (int i = 0; i < this.qNa.length; i++) {
        if (this.results[pos][i] == null) this.results[pos][i] = <String>[];
        this.results[pos][i].add(ans[i]);
      }
    });
  }

  Map<String, Map<int, List<String>>> getResults({List<String> filter}) {
    if (filter == null) return results;
    Map<String, Map<int, List<String>>> ret = results;
    ret.removeWhere((key, value) => !filter.contains(key));
    return ret;
  }

  STATUS _getStatus() {
    if (this.to.isBefore(DateTime.now())) return STATUS.Past;
    if (this.from.isBefore(DateTime.now())) return STATUS.Active;
    return STATUS.Upcoming;
  }
}

enum STATUS { Active, Past, Upcoming }
