import 'package:daily_app/services/authentication.dart';
import 'package:daily_app/views/RootPage.dart';
import 'package:flutter/material.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Daily',
        theme: ThemeData(
          primarySwatch: Colors.cyan,
        ),
        debugShowCheckedModeBanner: false,
        home: RootPage(auth: Authentication(),)
    );
  }
}
