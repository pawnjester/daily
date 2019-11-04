import 'package:firebase_database/firebase_database.dart';

class Daily {
  String _id;
  String _title;
  String _description;
  String _date;
  bool completed;

  Daily(this._title, this._date, this._description);

  String get id => _id;
  String get title => _title;
  String get description => _description;
  String get date => _date;

  set title(String newTitle) {
    if (newTitle.length <= 255) {
      this._title = newTitle;
    }
  }
  set description(String newDescription) {
    if(newDescription.length <= 255) {
      this._description = newDescription;
    }
  }
  set date(String newDate) {
    this.date = newDate;
  }

  Map<String, dynamic> toMap() {

    var map = Map<String, dynamic>();
    if (id != null) {
      map['id'] = _id;
    }
    map['title'] = _title;
    map['description'] = _description;
    map['date'] = _date;

    return map;
  }

   Daily.fromJson(Map<dynamic, dynamic> map) {
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
    this._date = map['date'];
  }

  Daily.fromSnapshot(DataSnapshot snapshot)
      : _id = snapshot.key,
        _title = snapshot.value['title'],
        _description = snapshot.value['description'],
        _date = snapshot.value['date'];

  toJson() {
    return {
      "title": _title,
      "description": _description,
      "date": _date
    };
  }

}