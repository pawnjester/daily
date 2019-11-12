import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:daily_app/model/daily.dart';
import 'package:daily_app/services/authentication.dart';
import 'package:daily_app/views/DailyDetail.dart';
import 'package:daily_app/views/DailyListItem.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class DailyList extends StatefulWidget {
  final String auth;

  DailyList({this.auth});

  @override
  _DailyListState createState() => _DailyListState();
}

class _DailyListState extends State<DailyList> {
  final logger = Logger();
  String userId = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Builder(
      builder: (context) => _buildBody(context),
    ));
  }


  _buildBody(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('Daily')
          .where("user", isEqualTo: widget.auth)
          .orderBy("completed", descending: true).snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();
        var result = snapshot.data;
        return _buildList(context, result.documents);
      },
    );
  }

  navigateToDetail(Daily todo, String title) async {
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return DailyDetail(todo, title);
    }));
  }

  getFirstLetter(String title) => title.substring(0, 1).toUpperCase();

  _buildList(BuildContext context, List<DocumentSnapshot> snapshot) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Daily'),
        ),
        body: ListView(
          padding: const EdgeInsets.only(top: 20.0),
          children:
          snapshot.map<Widget>((data) => _buildListItem(context, data)).toList(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            navigateToDetail(Daily('', '', '', false, null, null, widget.auth), 'Add Todo');
          },
          tooltip: 'Add Daily',
          child: Icon(Icons.add),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ));
  }

  _buildListItem(BuildContext context, DocumentSnapshot data) {
    final todo = Daily.fromSnapshot(data);
    return DailyItemList(todo);
  }
}
