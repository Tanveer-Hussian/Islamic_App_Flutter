
class Data {
  Data({
      List<Surahs>? surahs, 
      Edition? edition,}){
    _surahs = surahs!;
    _edition = edition!;
}

  Data.fromJson(dynamic json) {
    if (json['surahs'] != null) {
      _surahs = [];
      json['surahs'].forEach((v) {
        _surahs.add(Surahs.fromJson(v));
      });
    }
    _edition = (json['edition'] != null ? Edition.fromJson(json['edition']) : null)!;
  }
  late List<Surahs> _surahs;
  late Edition _edition;
Data copyWith({  List<Surahs>? surahs,
  Edition? edition,
}) => Data(  surahs: surahs ?? _surahs,
  edition: edition ?? _edition,
);
  List<Surahs> get surahs => _surahs;
  Edition get edition => _edition;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    if (_surahs != null) {
      map['surahs'] = _surahs.map((v) => v.toJson()).toList();
    }
    if (_edition != null) {
      map['edition'] = _edition.toJson();
    }
    return map;
  }

}


class Edition {
  Edition({
      String? identifier, 
      String? language, 
      String? name, 
      String? englishName, 
      String? format, 
      String? type,}){
    _identifier = identifier!;
    _language = language!;
    _name = name!;
    _englishName = englishName!;
    _format = format!;
    _type = type!;
}

  Edition.fromJson(dynamic json) {
    _identifier = json['identifier'];
    _language = json['language'];
    _name = json['name'];
    _englishName = json['englishName'];
    _format = json['format'];
    _type = json['type'];
  }
  late String _identifier;
  late String _language;
  late String _name;
  late String _englishName;
  late String _format;
  late String _type;
Edition copyWith({  String? identifier,
  String? language,
  String? name,
  String? englishName,
  String? format,
  String? type,
}) => Edition(  identifier: identifier ?? _identifier,
  language: language ?? _language,
  name: name ?? _name,
  englishName: englishName ?? _englishName,
  format: format ?? _format,
  type: type ?? _type,
);
  String get identifier => _identifier;
  String get language => _language;
  String get name => _name;
  String get englishName => _englishName;
  String get format => _format;
  String get type => _type;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['identifier'] = _identifier;
    map['language'] = _language;
    map['name'] = _name;
    map['englishName'] = _englishName;
    map['format'] = _format;
    map['type'] = _type;
    return map;
  }

}


class Surahs {
  Surahs({
      num? number, 
      String? name, 
      String? englishName, 
      String? englishNameTranslation, 
      String? revelationType, 
      List<Ayahs>? ayahs,}){
    _number = number!;
    _name = name!;
    _englishName = englishName!;
    _englishNameTranslation = englishNameTranslation!;
    _revelationType = revelationType!;
    _ayahs = ayahs!;
}

  Surahs.fromJson(dynamic json) {
    _number = json['number'];
    _name = json['name'];
    _englishName = json['englishName'];
    _englishNameTranslation = json['englishNameTranslation'];
    _revelationType = json['revelationType'];
    if (json['ayahs'] != null) {
      _ayahs = [];
      json['ayahs'].forEach((v) {
        _ayahs.add(Ayahs.fromJson(v));
      });
    }
  }
  late num _number;
  late String _name;
  late String _englishName;
  late String _englishNameTranslation;
  late String _revelationType;
  late List<Ayahs> _ayahs;
Surahs copyWith({  num? number,
  String? name,
  String? englishName,
  String? englishNameTranslation,
  String? revelationType,
  List<Ayahs>? ayahs,
}) => Surahs(  number: number ?? _number,
  name: name ?? _name,
  englishName: englishName ?? _englishName,
  englishNameTranslation: englishNameTranslation ?? _englishNameTranslation,
  revelationType: revelationType ?? _revelationType,
  ayahs: ayahs ?? _ayahs,
);
  num get number => _number;
  String get name => _name;
  String get englishName => _englishName;
  String get englishNameTranslation => _englishNameTranslation;
  String get revelationType => _revelationType;
  List<Ayahs> get ayahs => _ayahs;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['number'] = _number;
    map['name'] = _name;
    map['englishName'] = _englishName;
    map['englishNameTranslation'] = _englishNameTranslation;
    map['revelationType'] = _revelationType;
    if (_ayahs != null) {
      map['ayahs'] = _ayahs.map((v) => v.toJson()).toList();
    }
    return map;
  }

}


class Ayahs {
  Ayahs({
      num? number, 
      String? text, 
      num? numberInSurah, 
      num? juz, 
      num? manzil, 
      num? page, 
      num? ruku, 
      num? hizbQuarter, 
      bool? sajda,}){
    _number = number!;
    _text = text!;
    _numberInSurah = numberInSurah!;
    _juz = juz!;
    _manzil = manzil!;
    _page = page!;
    _ruku = ruku!;
    _hizbQuarter = hizbQuarter!;
    _sajda = sajda!;
 }

  Ayahs.fromJson(dynamic json) {
    _number = json['number'];
    _text = json['text'];
    _numberInSurah = json['numberInSurah'];
    _juz = json['juz'];
    _manzil = json['manzil'];
    _page = json['page'];
    _ruku = json['ruku'];
    _hizbQuarter = json['hizbQuarter'];
    _sajda = json['sajda'];
  }
  late num _number;
  late String _text;
  late num _numberInSurah;
  late num _juz;
  late num _manzil;
  late num _page;
  late num _ruku;
  late num _hizbQuarter;
  late bool _sajda;
Ayahs copyWith({  num? number,
  String? text,
  num? numberInSurah,
  num? juz,
  num? manzil,
  num? page,
  num? ruku,
  num? hizbQuarter,
  bool? sajda,
}) => Ayahs(  number: number ?? _number,
  text: text ?? _text,
  numberInSurah: numberInSurah ?? _numberInSurah,
  juz: juz ?? _juz,
  manzil: manzil ?? _manzil,
  page: page ?? _page,
  ruku: ruku ?? _ruku,
  hizbQuarter: hizbQuarter ?? _hizbQuarter,
  sajda: sajda ?? _sajda,
);
  num get number => _number;
  String get text => _text;
  num get numberInSurah => _numberInSurah;
  num get juz => _juz;
  num get manzil => _manzil;
  num get page => _page;
  num get ruku => _ruku;
  num get hizbQuarter => _hizbQuarter;
  bool get sajda => _sajda;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['number'] = _number;
    map['text'] = _text;
    map['numberInSurah'] = _numberInSurah;
    map['juz'] = _juz;
    map['manzil'] = _manzil;
    map['page'] = _page;
    map['ruku'] = _ruku;
    map['hizbQuarter'] = _hizbQuarter;
    map['sajda'] = _sajda;
    return map;
  }

}