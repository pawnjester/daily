import 'package:daily_app/views/LoginPage.dart';
import 'package:flutter/material.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'My Todo',
        theme: ThemeData(
          primarySwatch: Colors.cyan,
        ),
        debugShowCheckedModeBanner: false,
        home: LoginPage()
    );
  }
}
