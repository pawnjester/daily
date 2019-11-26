import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_app/model/daily.dart';
import 'package:daily_app/services/authentication.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

class DailyDetail extends StatefulWidget {
  final String appBarTitle;
  final Daily todo;
  final BaseAuth auth;

  DailyDetail(this.todo, this.appBarTitle, this.auth);
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
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Priority _priority = Priority.NoPriority;
  String taskVal;

  void handleDailyType(Priority value) {
    setState(() {
      _priority = value;
      switch (_priority.index) {
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

  DailyDetailState(this.todo, this.appBarTitle);

  @override
  void initState() {
    super.initState();
    _isButtonDisabled = false;
    titleController.addListener(updateTitle);
    descriptionController.addListener(updateDescription);
    switch (todo.priority) {
      case 'LowPriority':
        _priority = Priority.LowPriority;
        break;
      case 'MediumPriority':
        _priority = Priority.MediumPriority;
        break;
      case 'HighPriority':
        _priority = Priority.HighPriority;
        break;
      default:
        _priority = Priority.NoPriority;
        break;
    }
  }

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
          key: _scaffoldKey,
          appBar: AppBar(
            title: Text(appBarTitle),
            leading: IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  moveToLastScreen();
                }),
          ),
          body: Padding(
            padding: EdgeInsets.only(top: 15.0, left: 15.0, right: 15.0),
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
                Padding(
                  padding: const EdgeInsets.only(top: 30, bottom: 30),
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          "Set Time",
                          style: TextStyle(fontSize: 18),
                        ),
                      ),
                      Expanded(
                          child: GestureDetector(
                            onTap: () {
                              DatePicker.showTimePicker(
                                context,
                                onChanged: (date) {
                                  print('change $date');
                                },
                                onConfirm: (date) {
                                  print('confirm $date');
                                },
                                locale: LocaleType.en,
                                currentTime: DateTime.now()
                              );
                            },
                            child: Text(
                              "Tap To Set Time",
                              style: TextStyle(color: Colors.grey, fontSize: 18),
                              textAlign: TextAlign.end,
                            ),
                          ))
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Padding(
                      padding: const EdgeInsets.only(top: 8, bottom: 8),
                      child: Text(
                        'Select a Task Priority',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
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
                              _isButtonDisabled
                                  ? null
                                  : (todo.id == null
                                      ? _save(context)
                                      : _update(context));
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
                                _delete(context);
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

  @override
  void dispose() {
    super.dispose();
    titleController.dispose();
    descriptionController.dispose();
  }

  // Update the title of todo object
  void updateTitle() {
    if (titleController.text.length > 1) {
      setState(() {
        _isButtonDisabled = false;
      });
      todo.title = titleController.text;
    }
  }

  // Update the description of todo object
  void updateDescription() {
    if (descriptionController.text.length > 1) {
      setState(() {
        _isButtonDisabled = false;
      });
      todo.description = descriptionController.text;
    }
  }

  // Save data to database
  void _save(BuildContext context) {
    final todoReference = Firestore.instance;
    final uid = new Uuid();
    String id = uid.v1();
    try {
      if (titleController.text.length > 1 &&
          descriptionController.text.length > 1) {
        moveToLastScreen();
        widget.auth.getUser().then((user) {
          todoReference.collection('Daily').document().setData({
            'id': id,
            'title': todo.title,
            'description': todo.description,
            'completed': todo.completed,
            'priority': taskVal,
            'user': widget.todo.user
          });
        });
      } else {
        final snackbar =
            SnackBar(content: Text('You cannot save an Empty file'));
        Scaffold.of(context).showSnackBar(snackbar);
      }
    } on Exception catch (e) {
      final snackbar = SnackBar(content: Text('You cannot save an Empty file'));
      Scaffold.of(context).showSnackBar(snackbar);
    }
  }

  void _update(BuildContext context) async {
    try {
      if (todo.title.length > 1 && todo.description.length > 1) {
        moveToLastScreen();
        final todoReference = Firestore.instance;
        await todoReference
            .collection('Daily')
            .document(todo.reference.documentID)
            .updateData({
          'title': todo.title,
          'description': todo.description,
          'priority': taskVal
        });
      }
    } on Exception catch (e) {
      final snackbar =
          SnackBar(content: Text('You cannot update an Empty file'));
      Scaffold.of(context).showSnackBar(snackbar);
    }
  }

  void _delete(BuildContext context) async {
    try {
      moveToLastScreen();
      final todoReference = Firestore.instance;
      await todoReference
          .collection('Daily')
          .document(todo.reference.documentID)
          .delete();
    } on Exception catch (e) {
      final snackbar =
          SnackBar(content: Text('You cannot delete an Empty file'));
      Scaffold.of(context).showSnackBar(snackbar);
    }
  }
}

enum Priority { LowPriority, MediumPriority, HighPriority, NoPriority }
