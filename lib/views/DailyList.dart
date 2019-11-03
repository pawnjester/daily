import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_app/model/daily.dart';
import 'package:flutter/material.dart';

class DailyList extends StatefulWidget {
  @override
  _DailyListState createState() => _DailyListState();
}

class _DailyListState extends State<DailyList> {
  @override
  void initState() {
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Builder(
        builder: (context) => _buildBody(context),
      ),
    );
  }

  _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('Todo').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        var result = snapshot.data;
        return _buildList(context, result.documents);
      },
    );
  }

  _buildRow(BuildContext context, Daily todo) {
    return Dismissible(
        key: Key(todo.id),
        background: Container(
            alignment: AlignmentDirectional.centerEnd,
            color: Colors.red,
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Icon(Icons.delete),
            )
        ),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          _deleteSwipe(context, todo);
          Scaffold.of(context)
              .showSnackBar(SnackBar(content: Text("${todo.title} dismissed")));
        },
        child: Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.purpleAccent,
              child: Text(
                getFirstLetter(todo.title),
                style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
              ),
            ),
            title: Text(
              todo.title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(todo.description),
            onTap: () {
              navigateToDetail(todo, 'Edit Todo');
            },
          ),
        ));
  }

  navigateToDetail(Daily todo, String title) async {
//    await Navigator.push(context, MaterialPageRoute(builder: (context) {
//      return TodoDetail(todo, title);
//    }));
  }

  getFirstLetter(String title) => title.substring(0, 1).toUpperCase();

  _deleteSwipe(BuildContext context, Daily todo) async {
    final todoReference = Firestore.instance;
    await todoReference
        .collection('Todo')
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

  _buildListItem(BuildContext context,DocumentSnapshot data) {
    final todo = Daily.fromSnapshot(data);
    return _buildRow(context, todo);
  }
}
