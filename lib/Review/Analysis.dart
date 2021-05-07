import 'package:rankless/shared/Interface.dart';

class Analysis {
  String _companyUid;
  Set<String> activeCountries = {};
  List<String> _surveys = [];
  List<String> _companies = [];
  Map<int, List<double>> _myScore = Map<int, List<double>>();
  Map<int, List<Scores>> _data = Map<int, List<Scores>>();

  Analysis(this._companyUid);

  Future getData() async {
    int index = 0;
    await publicCollection
        .orderBy('number')
        .get()
        .then(
          (value) => value.docs.forEach((element) {
            _surveys.add(element.id);
          }),
        )
        .whenComplete(() async => await publicCollection.doc(_surveys[0]).collection('results').get().then(
              (value) => value.docs.forEach((element) {
                _companies.add(element.id);
              }),
            ))
        .whenComplete(() async => await Future.forEach(_surveys, (s) async {
              await Future.forEach(_companies, (c) async {
                await publicCollection.doc(s).collection('results').doc(c).get().then((value) {
                  String industry = value.data()['industry'];
                  String country = value.data()['country'];
                  activeCountries.add(country);
                  List<double> ocjene = List<double>.filled(6, 0);
                  for (int i = 0; i < 5; i++) {
                    ocjene[i] = value.data()['sum' + i.toString()] / value.data()['total'];
                    ocjene[5] += ocjene[i];
                  }
                  ocjene[5] /= 5;
                  if (_data[index] == null) _data[index] = [];
                  _data[index].add(Scores(
                    country,
                    industry,
                    ocjene,
                  ));
                  if (c == _companyUid) _myScore[index] = ocjene;
                });
              });
              index++;
            }))
        .whenComplete(() => _data.forEach((key, value) {
              print(key);
              value.forEach((element) {
                print(element.score);
              });
            }));
  }

  double getMaxScore(int index, int category, {String country, String industry}) {
    double ret = 0;
    for (int i = 0; i < _data[index].length; i++) {
      if (country != null && country != _data[index][i].country) continue;
      if (industry != null && industry != _data[index][i].industry) continue;
      if (_data[index][i].score[category] > ret) ret = _data[index][i].score[category];
    }
    return ret;
  }

  double getAvgScore(int index, int category, {String country, String industry}) {
    double ret = 0;
    int count = 0;
    for (int i = 0; i < _data[index].length; i++) {
      if (country != null && country != _data[index][i].country) continue;
      if (industry != null && industry != _data[index][i].industry) continue;
      ret += _data[index][i].score[category];
      count++;
    }
    return ret / count;
  }

  double getMyScore(int index, int category) {
    return _myScore[index][category];
  }

  int getPosition(int category, {String country, String industry}) {
    int index = _surveys.length - 1;
    int better = 0;
    int count = 0;
    for (int i = 0; i < _data[index].length; i++) {
      if (country != null && country != _data[index][i].country) continue;
      if (industry != null && industry != _data[index][i].industry) continue;
      if (_data[index][i].score[category] > _myScore[index][category]) better++;
      count++;
    }
    return ((better / count) * 100).round() + 1;
  }

  int getNumOfSurveys() {
    return _surveys.length;
  }

  String getMessage(int category, {String country, String industry}) {
    int index = _surveys.length - 1;
    int requiredPercentage = getPosition(category, country: country, industry: industry);
    int upgrade = requiredPercentage > 5 ? 5 : requiredPercentage;
    requiredPercentage += upgrade;
    double ans = _myScore[index][category];
    for (; ans <= 5; ans += 0.1) {
      int better = 0;
      int count = 0;
      for (int i = 0; i < _data[index].length; i++) {
        if (country != null && country != _data[index][i].country) continue;
        if (industry != null && industry != _data[index][i].industry) continue;
        if (_data[index][i].score[category] < ans - e) better++;
        count++;
      }
      if (better / count * 100 > requiredPercentage) break;
    }
    int actualPosition = getPosition(category, country: country, industry: industry);
    double actualScore = _myScore[index][category];
    _myScore[index][category] = ans;
    int fakePosition = getPosition(category, country: country, industry: industry);
    _myScore[index][category] = actualScore;
    int actualUpgrade = actualPosition - fakePosition;
    ans -= _myScore[index][category];

    return "To get $actualUpgrade% better score your score need to improve by " + ans.toStringAsFixed(1);
  }
}

class Scores {
  String country;
  String industry;
  List<double> score = List<double>.filled(6, 0);
  Scores(this.country, this.industry, this.score);
}
