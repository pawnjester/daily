import 'package:daily_app/model/daily.dart';
import 'package:daily_app/views/DailyDetail.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:logger/logger.dart';

class DailyList extends StatefulWidget {
  @override
  _DailyListState createState() => _DailyListState();
}

class _DailyListState extends State<DailyList> {
  final logger = Logger();
  Daily daily;
  DatabaseReference reference;
  List<Daily> items =List();

  @override
  void initState() {
    super.initState();
    reference = FirebaseDatabase.instance.reference();
    daily= Daily("", "", "");
    reference.onChildAdded.listen(_onEntryAdded);
    reference.onChildChanged.listen(_onEntryChanged);
  }

  _onEntryAdded(Event event) {
    setState(() {
      items.add(Daily.fromSnapshot(event.snapshot));
    });
  }

//  _onEntryChanged(Event event) {
//    setState(() {
//      var old = items.singleWhere((entry) {
//        return entry. == event.snapshot.key;
//      });
//      setState(() {
//        items[Daily.indexOf(old)] = Shop.fromSnapshot(event.snapshot);
//      });
//    });
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Builder(
          builder: (context) => _buildBody(context),
    ));
  }

  _buildBody(BuildContext context) {
    return StreamBuilder<Event>(
      stream: databaseReference.onValue,
      builder: (context, AsyncSnapshot<Event> event) {
        if (event.hasData) {
          var result = event.data.snapshot.value;
          final convert = Daily.fromJson(result);
          var damn = _buildList(context, convert);
          return damn;
        }
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
            )),
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
                style:
                    TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
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
    await Navigator.push(context, MaterialPageRoute(builder: (context) {
      return DailyDetail(todo, title);
    }));
  }

  getFirstLetter(String title) => title.substring(0, 1).toUpperCase();

  _deleteSwipe(BuildContext context, Daily todo) async {
//    final todoReference = Firestore.instance;
//    await todoReference
//        .collection('Todo')
//        .document(todo.reference.documentID)
//        .delete();
  }

  _buildList(BuildContext context, List<DataSnapshot> snapshot) {
    logger.e("herree>>>>@@@@+++");
    return Scaffold(
        appBar: AppBar(
          title: Text('My Todo'),
        ),
        body: ListView(
          padding: const EdgeInsets.only(top: 20.0),
          children: snapshot
              .map<Widget>((data) => _buildListItem(context, data)).toList()
              .toList(),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            navigateToDetail(
                Daily('', '', ''),
                'Add Todo');
          },
          tooltip: 'Add Todo',
          child: Icon(Icons.add),
          backgroundColor: Colors.black,
          foregroundColor: Colors.white,
        ));
  }

  _buildListItem(BuildContext context, DataSnapshot data) {
    final todo = Daily.fromSnapshot(data);
    return _buildRow(context, todo);
  }
}
