import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_app/model/daily.dart';
import 'package:daily_app/views/DailyDetail.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';
import 'package:random_color/random_color.dart';

class DailyList extends StatefulWidget {
  @override
  _DailyListState createState() => _DailyListState();
}

class _DailyListState extends State<DailyList> {
  final logger = Logger();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Builder(
      builder: (context) => _buildBody(context),
    ));
  }


  _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('Daily').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        var result = snapshot.data;
        return _buildList(context, result.documents);
      },
    );
  }

  _buildRow(BuildContext context, Daily daily) {
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
              backgroundColor: RandomColor().randomColor(),
              child: Text(
                getFirstLetter(daily.title),
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            title: Text(
              daily.title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(daily.description),
            onTap: () {
              navigateToDetail(daily, 'Edit Todo');
            },
          ),
        ));
  }

  navigateToDetail(Daily todo, String title) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return DailyDetail(todo, title);
    }));
  }

  getFirstLetter(String title) => title.substring(0, 1).toUpperCase();

  _deleteSwipe(BuildContext context, Daily todo) async {
    final todoReference = Firestore.instance;
    await todoReference
        .collection('Daily')
        .document(todo.reference.documentID)
        .delete();
  }

  _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return Scaffold(
        appBar: AppBar(
          title: Text('My Todo'),
        ),
        body: ListView(
          padding: const EdgeInsets.only(top: 20.0),
          children:
          snapshot.map<Widget>((data) => _buildListItem(context, data)).toList(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            navigateToDetail(Daily('', '', '', null), 'Add Todo');
          },
          tooltip: 'Add Todo',
          child: Icon(Icons.add),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ));
  }

  _buildListItem(BuildContext context, DocumentSnapshot data) {
    final todo = Daily.fromSnapshot(data);
    return _buildRow(context, todo);
  }
}
