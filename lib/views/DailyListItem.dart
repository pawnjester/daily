import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_app/model/daily.dart';
import 'package:daily_app/views/DailyDetail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class DailyItemList extends StatefulWidget {
  final Daily daily;

  DailyItemList(Daily daily)
      : daily = daily,
        super(key: ObjectKey(daily));

  @override
  State<StatefulWidget> createState() {
    return DailyItemListState(daily);
  }
}

class DailyItemListState extends State<DailyItemList> {
  final Daily daily;
  DailyItemListState(this.daily);

  @override
  Widget build(BuildContext context) {
    return Dismissible(
        key: Key(daily.id),
        background: Container(
            alignment: AlignmentDirectional.centerEnd,
            color: Colors.red,
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Icon(Icons.delete),
            )),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          _deleteSwipe(context, daily);
          Scaffold.of(context).showSnackBar(
              SnackBar(content: Text("${daily.title} dismissed")));
        },
        child: Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.transparent,
              child: Text(
                getFirstLetter(daily.title),
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            trailing: Checkbox(
              value: daily.completed,
              onChanged: (bool value) {
                setState(() {
                  daily.completed = value;
                });
                _updateCheckBox(value, daily);
              },
            ),
            title: Text(
              daily.title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(daily.description),
            onTap: () {
              navigateToDetail(daily, 'Edit Daily');
            },
          ),
        ));
  }

  getFirstLetter(String title) => title.substring(0, 1).toUpperCase();

  navigateToDetail(Daily todo, String title) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return DailyDetail(todo, title);
    }));
  }

  _deleteSwipe(BuildContext context, Daily todo) async {
    final todoReference = Firestore.instance;
    await todoReference
        .collection('Daily')
        .document(todo.reference.documentID)
        .delete();
  }

  void _updateCheckBox(bool value, Daily daily) async {
    final todoReference = Firestore.instance;
    await todoReference
        .collection('Daily')
        .document(daily.reference.documentID)
        .updateData({'completed': value});
  }

  Widget dailyType(String type) {
    IconData iconValue;
    Color colorValue;
    switch (type) {
      case 'LowPriority':
        iconValue = FontAwesomeIcons.star;
        colorValue = Color(0xffffc04d);
        break;
      case 'MediumPriority':
        iconValue = FontAwesomeIcons.star;
        colorValue = Color(0xffffa500);
        break;
      case 'HighPriority':
        iconValue = FontAwesomeIcons.star;
        colorValue = Color(0xffffa500);
        break;
      default:
        iconValue = FontAwesomeIcons.star;
        colorValue = Color(0xffffa500);
    }
    return CircleAvatar(
      backgroundColor: colorValue,
      child: Icon(iconValue, color: Colors.white, size: 20),
    );
  }
}
