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
                    ocjene[5] += ocjene[i] / 5;
                  }
                  if (_data[index] == null) _data[index] = [];
                  _data[index].add(Scores(
                    country,
                    industry,
                    ocjene,
                  ));
                  print(index);
                  if (c == _companyUid) _myScore[index] = ocjene;
                });
              });
              index++;
            }));
  }

  double getMaxScore(int index, int category, {String country, String industry}) {
    double ret = 0;
    for (int i = 0; i < _data[index].length; i++) {
      if (country != null && country != _data[index][i].country) continue;
      if (industry != null && industry != _data[index][i].industry) continue;
      if (_data[index][i].score[5] > ret) ret = _data[index][i].score[category];
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
    print(_myScore);
    print(index);
    print(category);
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
    return ((better / count) * 100).round();
  }

  int getNumOfSurveys() {
    return _surveys.length;
  }
}

class Scores {
  String country;
  String industry;
  List<double> score = List<double>.filled(6, 0);
  Scores(this.country, this.industry, this.score);
}
