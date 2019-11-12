import 'package:cloud_firestore/cloud_firestore.dart';

class Daily {
  String _id;
  String _title;
  String _description;
  String _date;
  bool _completed;
  String _priority;
  String _user;


  String get user => _user;

  set user(String value) {
    _user = value;
  }

  final DocumentReference reference;

  Daily(
      this._title,
      this._date,
      this._description,
      this._completed,
      this._priority,
      this.reference,
      this._user);

  String get id => _id;
  String get title => _title;
  String get description => _description;
  String get date => _date;
  bool get completed => _completed;
  String get priority => _priority;

  set priority(String value) {
    _priority = value;
  }

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

  set completed(bool completed) {
    _completed = completed;
  }


  Daily.fromMapObject(Map<String, dynamic> map, {this.reference}) {
    this._id = map['id'];
    this._title = map['title'];
    this._description = map['description'];
    this._date = map['date'];
    this._completed = map['completed'];
    this._priority = map['priority'];
    this._user = map['user'];
  }

  Daily.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMapObject(snapshot.data, reference: snapshot.reference);


}
