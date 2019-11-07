import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_app/model/daily.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

class DailyDetail extends StatefulWidget {
  final String appBarTitle;
  final Daily todo;

  DailyDetail(this.todo, this.appBarTitle);
  @override
  State<StatefulWidget> createState() =>
      DailyDetailState(this.todo, this.appBarTitle);
}

class DailyDetailState extends State<DailyDetail> {
  String appBarTitle;
  Daily todo;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  DailyDetailState(this.todo, this.appBarTitle);
//  final databaseReference = FirebaseDatabase.instance.reference();

  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    titleController.text = todo.title;
    descriptionController.text = todo.description;

    return WillPopScope(
        onWillPop: () {
          moveToLastScreen();
        },
        child: Scaffold(
          appBar: AppBar(
            title: Text(appBarTitle),
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  moveToLastScreen();
                }),
          ),
          body: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
            child: ListView(
              children: <Widget>[
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: titleController,
                    style: textStyle,
                    onChanged: (value) {
                      updateTitle();
                    },
                    decoration: InputDecoration(
                      labelText: 'Title',
                      labelStyle: textStyle,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: TextField(
                    controller: descriptionController,
                    style: textStyle,
                    onChanged: (value) {
                      debugPrint('Something changed in Description Text Field');
                      updateDescription();
                    },
                    decoration: InputDecoration(
                      labelText: 'Description',
                      labelStyle: textStyle,
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 15.0, bottom: 15.0),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: RaisedButton(
                          color: Theme.of(context).primaryColorDark,
                          textColor: Theme.of(context).primaryColorLight,
                          child: Text(
                            todo.id == null ? 'Save' : 'Edit',
                            textScaleFactor: 1.5,
                          ),
                          onPressed: () {
                            setState(() {
                              todo.id == null ? _save() : _update();
                            });
                          },
                        ),
                      ),
                      Container(
                        width: 5.0,
                      ),
                      Visibility(
                        visible: todo.id == null ? false : true,
                        child: Expanded(
                          child: RaisedButton(
                            color: Theme.of(context).primaryColorDark,
                            textColor: Theme.of(context).primaryColorLight,
                            child: Text(
                              'Delete',
                              textScaleFactor: 1.5,
                            ),
                            onPressed: () {
                              setState(() {
                                _delete();
                              });
                            },
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
        ));
  }

  void moveToLastScreen() {
    Navigator.pop(context, true);
  }

  // Update the title of todo object
  void updateTitle() {
    todo.title = titleController.text;
  }

  // Update the description of todo object
  void updateDescription() {
    todo.description = descriptionController.text;
  }

  // Save data to database
  void _save() async {
    final todoReference = Firestore.instance;
    final uid = new Uuid();
    String id = uid.v1();
    if( todo.title.length > 1 && todo.description.length > 1) {
      moveToLastScreen();
      await todoReference.collection('Daily').document()
          .setData({'id': id,'title': todo.title, 'description': todo.description});
    } else {
      // final snackbar = SnackBar(content: Text('You cannot save an Empty file'));
      // Scaffold.of(context).showSnackBar(snackbar);
    }
  }

  void _update() async {
    if (todo.title.length > 1 && todo.description.length > 1) {
      moveToLastScreen();
      final todoReference = Firestore.instance;
      await todoReference.collection('Daily').document(todo.reference.documentID)
          .updateData({'title': todo.title, 'description': todo.description});
    }
  }

  void _delete() async {
    moveToLastScreen();
    final todoReference = Firestore.instance;
    await todoReference.collection('Daily').document(todo.reference.documentID).delete();
  }
}
