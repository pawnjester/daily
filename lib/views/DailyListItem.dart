import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_app/model/daily.dart';
import 'package:daily_app/views/DailyDetail.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
    return InkWell(
      onTap: () {
        navigateToDetail(daily, 'Edit Daily');
      },
      child: Dismissible(
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
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 80,
              decoration: BoxDecoration(
                border: Border.all(width: 2, color: Colors.black38),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CircleAvatar(
                          child: Text(
                            getFirstLetter(daily.title)
                          ),
                        )
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(daily.title, style: TextStyle(fontSize: 15,
                                fontWeight: FontWeight.bold),),
                          ),
                        ),
                        Expanded(child: Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: Text(daily.description),
                        ))
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        dailyType(daily.priority)
                      ],
                    ),
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Checkbox(
                          value: daily.completed,
                          onChanged: (bool value) {
                            setState(() {
                              daily.completed = value;
                            });
                            _updateCheckBox(value, daily);
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )
      ),
    );
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
    Color colorValue;
    switch (type) {
      case 'LowPriority':
        colorValue = Color(0xffAAFF00);
        break;
      case 'MediumPriority':
        colorValue = Color(0xffffa500);
        break;
      case 'HighPriority':
        colorValue = Color(0xffFF2929);
        break;
      default:
        colorValue = Color(0xfffff500);
    }
    return CircleAvatar(
      backgroundColor: colorValue,
      radius: 12,
    );
  }
}
