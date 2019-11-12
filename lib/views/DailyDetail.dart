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
  bool _isButtonDisabled;

  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  Priority _priority = Priority.NoPriority;
  String taskVal;

  void handleDailyType(Priority value) {
    setState(() {
      _priority = value;
      switch(_priority.index) {
        case 0:
          taskVal = 'LowPriority';
          break;
        case 1:
          taskVal = 'MediumPriority';
          break;
        case 2:
          taskVal = 'HighPriority';
          break;
      }
    });
  }
  final logger = Logger();

  DailyDetailState(this.todo, this.appBarTitle);

  @override
  void initState() {
    super.initState();
    _isButtonDisabled = false;
  }
  @override
  Widget build(BuildContext context) {
    TextStyle textStyle = Theme.of(context).textTheme.title;

    titleController.text = todo.title;
    descriptionController.text = todo.description;
    logger.e(todo.priority);


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
                      updateDescription();
                    },
                    decoration: InputDecoration(
                      labelText: 'Description',
                      labelStyle: textStyle,
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: Text(
                        'Select the Task Priority',
                        style: TextStyle(
                          fontSize: 18,
                        ),),
                    )
                  ],
                ),
                Column(
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Radio(
                          value: Priority.LowPriority,
                          onChanged: handleDailyType,
                          groupValue: _priority,
                          activeColor: Theme.of(context).primaryColorDark,
                        ),
                        Text(
                          'Low Priority',
                          style: TextStyle(fontSize: 16),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Radio(
                          value: Priority.MediumPriority,
                          onChanged: handleDailyType,
                          groupValue: _priority,
                          activeColor: Theme.of(context).primaryColorDark,
                        ),
                        Text(
                          'Medium Priority',
                          style: TextStyle(fontSize: 16),
                        )
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Radio(
                          value: Priority.HighPriority,
                          onChanged: handleDailyType,
                          groupValue: _priority,
                          activeColor: Theme.of(context).primaryColorDark,
                        ),
                        Text(
                          'High Priority',
                          style: TextStyle(fontSize: 16),
                        )
                      ],
                    ),
                  ],
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
                              _isButtonDisabled ? null : (todo.id == null ? _save(context) : _update());
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
  void _save(BuildContext context) async {
    final todoReference = Firestore.instance;
    final uid = new Uuid();
    String id = uid.v1();
    if( todo.title.length > 1 && todo.description.length > 1) {
      moveToLastScreen();
      await todoReference.collection('Daily').document()
          .setData({'id': id,'title': todo.title,
        'description': todo.description, 'completed' : todo.completed, 'priority': taskVal });
    } else {
      _isButtonDisabled = true;
      final snackbar = SnackBar(content: Text('You cannot save an Empty file'));
      Scaffold.of(context).showSnackBar(snackbar);
    }
  }

  void _update() async {
    if (todo.title.length > 1 && todo.description.length > 1) {
      moveToLastScreen();
      final todoReference = Firestore.instance;
      await todoReference.collection('Daily').document(todo.reference.documentID)
          .updateData({'title': todo.title, 'description': todo.description, 'priority': taskVal});
    }
  }

  void _delete() async {
    moveToLastScreen();
    final todoReference = Firestore.instance;
    await todoReference.collection('Daily').document(todo.reference.documentID).delete();
  }
}

enum Priority {
  LowPriority,
  MediumPriority,
  HighPriority,
  NoPriority
}

