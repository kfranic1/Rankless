import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:rankless/shared/Interface.dart';

class Analysis {
  int startIndex = 0;
  int solvedSurveys = 0;
  String _companyUid;
  Set<String> activeCountries = Set<String>();
  Map<int, List<double>> _myScore = Map<int, List<double>>();
  Map<int, List<Scores>> _data = Map<int, List<Scores>>();

  Analysis(this._companyUid);

  Future getData() async {
    int index = 0;
    bool skip = true;
    await publicCollection.orderBy('number').get().then((value) async {
      await Future.forEach(value.docs, (QueryDocumentSnapshot element) async {
        await publicCollection.doc(element.id).collection('results').get().then((value) {
          startIndex++;
          if (skip) skip = value.docs.fold(true, (previousValue, temp) => previousValue & (temp.id != _companyUid));
          if (skip) return;
          startIndex--;
          solvedSurveys++;
          _myScore[index] = List<double>.filled(6, 0);
          value.docs.forEach((value) {
            String industry = value.data()['industry'];
            String country = value.data()['country'];
            activeCountries.add(country);
            List<double> ocjene = List<double>.filled(6, 0);
            for (int i = 0; i < 5; i++) {
              ocjene[i] = value.data()['sum' + i.toString()] / max(1, value.data()['total'] as int);
              ocjene[5] += ocjene[i];
            }
            ocjene[5] /= 5;
            if (_data[index] == null) _data[index] = [];
            _data[index].add(Scores(
              country,
              industry,
              ocjene,
            ));
            if (value.id == _companyUid) _myScore[index] = ocjene;
          });
        });
        if (!skip) index++;
      });
    });
  }

  double getMaxScore(int index, int category, {String country, String industry}) {
    double ret = 0;
    for (int i = 0; i < _data[index].length; i++) {
      if (country != null && country != _data[index][i].country) continue;
      if (industry != null && industry != _data[index][i].industry) continue;
      if (_data[index][i].score[category] > ret) ret = _data[index][i].score[category];
    }
    return fix(ret);
  }

  int getFirstMonth() {
    return (4 + startIndex) % 12;
  }

  double getAvgScore(int index, int category, {String country, String industry}) {
    double ret = 0;
    int count = 0;
    for (int i = 0; i < _data[index].length; i++) {
      if (country != null && country != _data[index][i].country) continue;
      if (industry != null && industry != _data[index][i].industry) continue;
      if (_data[index][i].score[5] == 0) continue; //Discard surveys that weren't filled
      ret += _data[index][i].score[category];
      count++;
    }
    if (count == 0) return 0;
    return fix(ret / count);
  }

  double getMyScore(int index, int category) {
    return fix(_myScore[index][category]);
  }

  int getPosition(int category, {String country, String industry}) {
    int index = solvedSurveys - 1;
    int better = 0;
    int count = 0;
    for (int i = 0; i < _data[index].length; i++) {
      if (country != null && country != _data[index][i].country) continue;
      if (industry != null && industry != _data[index][i].industry) continue;
      if (_data[index][i].score[category] > _myScore[index][category]) better++;
      count++;
    }
    if (count == 0) return 0;
    return ((better / count + 0.005) * 100).round();
  }

  ///number of solved surveys
  int getNumOfSurveys() {
    return solvedSurveys;
  }

  String getMessage(int category, {String country, String industry}) {
    int index = solvedSurveys - 1;
    int requiredPercentage = getPosition(category, country: country, industry: industry);
    if (requiredPercentage <= 5) return 'You are already in top 5% in this category';
    requiredPercentage -= 5;
    double ans = _myScore[index][category];
    for (; ans <= 5 + e; ans += 0.01) {
      int better = 0;
      int count = 0;
      for (int i = 0; i < _data[index].length; i++) {
        if (country != null && country != _data[index][i].country) continue;
        if (industry != null && industry != _data[index][i].industry) continue;
        if (_data[index][i].score[category] > ans - e) better++;
        count++;
        //print(better.toString() + '/' + count.toString());
      }
      if (better / count * 100 < requiredPercentage) break;
    }
    int actualPosition = getPosition(category, country: country, industry: industry);
    double actualScore = _myScore[index][category];
    _myScore[index][category] = ans;
    int fakePosition = getPosition(category, country: country, industry: industry);
    _myScore[index][category] = actualScore;
    int actualUpgrade = actualPosition - fakePosition;
    ans -= _myScore[index][category];
    ans += e;
    return "If you improve your score by " + ans.toStringAsFixed(1) + " you will rise by $actualUpgrade%";
    //return "To get $actualUpgrade% better score your score needs to improve by " + ans.toStringAsFixed(1);
  }

  ///round to [1] decimal point
  double fix(double x) {
    return (x * 10).roundToDouble() / 10;
  }
}

class Scores {
  String country;
  String industry;
  List<double> score = List<double>.filled(6, 0);
  Scores(this.country, this.industry, this.score);
}
