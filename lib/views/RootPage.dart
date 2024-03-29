import 'package:daily_app/services/authentication.dart';
import 'package:daily_app/views/DailyList.dart';
import 'package:daily_app/views/DailyListItem.dart';
import 'package:daily_app/views/LoginPage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

enum AuthStatus { LOGGED_IN, NOT_LOGGEDIN, NOT_DETERMINED }

class RootPage extends StatefulWidget {
  final BaseAuth auth;
  RootPage({this.auth});

  @override
  _RootPageState createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  String _userId = "";

  String get userId => _userId;

  AuthStatus authStatus = AuthStatus.NOT_DETERMINED;
  final localNotifications = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    initializeNotification();
    widget.auth.getUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user?.uid;
        }
        authStatus =
            user?.uid == null ? AuthStatus.NOT_LOGGEDIN : AuthStatus.LOGGED_IN;
      });
    });
  }

  void initializeNotification() {
//    final initializationSettingsAndroid =
//        AndroidInitializationSettings('app_icon');
//
//    final initializationSettingsIOS = IOSInitializationSettings(
//        onDidReceiveLocalNotification: (id, title, description, payload) =>
//            onSelectNotification(payload));
//    final initializationSettings = InitializationSettings(
//        initializationSettingsAndroid, initializationSettingsIOS);

//    localNotifications.initialize(initializationSettings,
//        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payload) async => await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => DailyItemList(
                payload: payload,
              )));

  void loginCallback() {
    widget.auth.getUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
      });
    });
    setState(() {
      authStatus = AuthStatus.LOGGED_IN;
    });
  }

  void logoutCallback() {
    setState(() {
      authStatus = AuthStatus.NOT_LOGGEDIN;
      _userId = "";
    });
  }

  Widget buildWaitScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    switch (authStatus) {
      case AuthStatus.NOT_DETERMINED:
        return buildWaitScreen();
        break;
      case AuthStatus.LOGGED_IN:
        if (_userId.length > 0 && _userId != null) {
          return DailyList(
              user: userId, logoutCallback: logoutCallback, auth: widget.auth);
        } else
          return buildWaitScreen();
        break;
      case AuthStatus.NOT_LOGGEDIN:
        return LoginPage(
          auth: widget.auth,
          loginCallback: loginCallback,
        );
        break;
      default:
        return buildWaitScreen();
    }
  }
}
