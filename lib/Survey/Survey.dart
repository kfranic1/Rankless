import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rankless/User/Company.dart';
import 'package:rankless/User/Employee.dart';
import 'package:rankless/shared/Interface.dart';

import 'Question.dart';

class Survey {
  Company company;
  String uid;
  String name;
  List<Question> qNa = [];
  List<String> tags = [];
  DateTime from = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day);
  DateTime to = DateTime(DateTime.now().year, DateTime.now().month, DateTime.now().day).add(Duration(days: 7));
  STATUS status;
  Map<String, Map<int, List<String>>> results = new Map<String, Map<int, List<String>>>();
  bool hasData = false;
  bool isPublic = true; //TODO treba bit false

  Survey({this.uid, this.name, this.company});

  Future createSurvey() async {
    DocumentReference ref = surveyCollection.doc();
    await ref.set({
      'name': this.name,
      'question': qNa.map((e) => e.toMap()).toList(),
      'from': this.from.toString(),
      'to': this.to.toString(),
      'tags': this.tags,
      'public': true, //TODO treba bit false
    });
    this.uid = ref.id;
    await company.updateCompany(newSurvey: this);
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
    if (!hasData) {
      updateData(await surveyCollection.doc(this.uid).get());
      hasData = true;
    }
    if (withResults) await _getResults();
    return this;
  }

  Survey updateData(DocumentSnapshot ref) {
    this.name = ref['name'];
    this.from = DateTime.parse(ref['from']);
    this.to = DateTime.parse(ref['to']);
    dynamic questions = ref['question'];
    this.qNa = (questions as List<dynamic>).map((e) => e as Map<String, dynamic>).map((e) => Question().fromMap(e)).toList();
    this.tags = List<String>.from(ref['tags'] as List<dynamic>);
    this.status = _getStatus();
    this.isPublic = ref['public'];
    return this;
  }

  /// Must recieve [Provied.of<Employee>(context)] in other words [me]
  ///
  /// Submits [this] survey done by [me]
  Future submitSurvey(Employee who, {String industry, String country}) async {
    bool failed = false;
    if (isPublic) {
      FirebaseFirestore.instance.runTransaction((transaction) async {
        await publicCollection.doc(this.uid).collection('results').doc(who.companyUid).get().then((mapa) async {
          Map<String, dynamic> add = mapa.data() ??
              {
                'total': 0,
                'sum': 0,
                'country' : country,
                'industry' : industry,
              };
          for (int i = 0; i < 5; i++) {
            add['sum' + 1.toString()] = int.parse(add['sum'] + 1.toString()) + getFromMask(qNa[i].mask);
          }
          add['total'] = int.parse(add['total']) + 1;
          transaction.set(
            publicCollection.doc(this.uid).collection('results').doc(who.companyUid),
            add,
          );
        });
      }).onError((error, stackTrace) {
        failed = true;
      });
    } else
      await resultCollection.doc(this.uid).set({
        who.uid: {
          'pos': who.position,
          'ans': qNa.map((e) {
            if (e.answerType == TYPE.Text) return e.singleAnswer;
            return e.mask.toString();
          }).toList()
        }
      }, SetOptions(merge: true)).onError((error, stackTrace) => failed = true);
    if (failed) return;
    who.surveys.remove(this);
    await who.updateEmployee(newSurveys: who.surveys);
  }

  Future _getResults() async {
    DocumentSnapshot data = await resultCollection.doc(this.uid).get();
    if (!data.exists) return;
    results.clear();
    data.data().forEach((key, value) {
      String pos = value['pos'];
      if (this.results[pos] == null) this.results[pos] = new Map<int, List<String>>();
      List<String> ans = List<String>.from(value['ans'] as List<dynamic>);
      for (int i = 0; i < this.qNa.length; i++) {
        if (this.results[pos][i] == null) this.results[pos][i] = <String>[];
        this.results[pos][i].add(ans[i]);
      }
    });
    Map<int, List<String>> other = new Map<int, List<String>>();
    for (String key in this.results.keys.toList()) {
      if (this.results[key][0].length == 1) {
        Map<int, List<String>> temp = this.results.remove(key);
        for (int i = 0; i < temp.keys.length; i++) {
          if (other[i] == null) other[i] = <String>[];
          other[i].add(temp[i][0]);
        }
      }
    }
    if (other.values.length != 0) this.results.addAll({'Other': other});
  }

  /// Returns Map with following structure [position, Map<question_number, answers>]
  ///
  /// Adding [filter] will return map containing [position] that are in [filter]
  Map<String, Map<int, List<String>>> getResults({List<String> filter}) {
    if (filter == null) return results;
    Map<String, Map<int, List<String>>> ret = Map<String, Map<int, List<String>>>();
    ret.addAll(results);
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
