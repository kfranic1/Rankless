import 'package:rankless/shared/Interface.dart';

class Analysis {
  String _companyUid;
  Set<String> activeCountries = {};
  List<String> _surveys = [];
  List<String> _companies = [];
  List<double> _myScore = List<double>.filled(6, 0);
  List<Scores> _data = [];

  Analysis(this._companyUid);

  Future getData() async {
    await publicCollection
        .get()
        .then(
          (value) => value.docs.forEach((element) {
            _surveys.add(element.id);
          }),
        )
        .whenComplete(
          () async => await publicCollection.doc(_surveys[0]).collection('results').get().then(
                (value) => value.docs.forEach((element) {
                  _companies.add(element.id);
                }),
              ),
        );
    await Future.forEach(_surveys, (s) async {
      await Future.forEach(_companies, (c) async {
        await publicCollection.doc(s).collection('results').doc(c).get().then((value) {
          print(value.data());
          String industry = value.data()['industry'];
          String country = value.data()['country'];
          activeCountries.add(country);
          List<double> ocjene = List<double>.filled(6, 0);
          for (int i = 0; i < 5; i++) {
            ocjene[i] = value.data()['sum' + i.toString()] / value.data()['total'];
            ocjene[5] += ocjene[i] / 5;
          }
          _data.add(Scores(
            country,
            industry,
            ocjene,
          ));
          if (c == _companyUid) _myScore = ocjene;
        });
      });
    });
  }

  List<double> getMaxScore({String country, String industry}) {
    List<double> ret = List<double>.filled(6, 0);
    for (int i = 0; i < _data.length; i++) {
      if (country != null && country != _data[i].country) continue;
      if (industry != null && industry != _data[i].industry) continue;
      if (_data[i].score[5] > ret[5]) ret = _data[i].score;
    }
    return ret;
  }

  List<double> getAvgScore({String country, String industry}) {
    List<double> ret = List<double>.filled(6, 0);
    int count = 0;
    for (int i = 0; i < _data.length; i++) {
      if (country != null && country != _data[i].country) continue;
      if (industry != null && industry != _data[i].industry) continue;
      for (int j = 0; j < 6; j++) ret[j] += _data[i].score[j];
      count++;
    }
    for (int i = 0; i < 6; i++) ret[i] /= count;
    return ret;
  }

  List<double> getMyScore() {
    return _myScore;
  }
}

class Scores {
  String country;
  String industry;
  List<double> score = List<double>.filled(6, 0);
  Scores(this.country, this.industry, this.score);
}
