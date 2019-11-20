import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

NotificationDetails get _ongoing {
  final androidPlatformChannelSpecifics = AndroidNotificationDetails(
    'your channel id',
    'your channel name',
    'your channel description',
    importance: Importance.Max,
    priority: Priority.High,
    ongoing: true,
    autoCancel: false,
  );
  final iOSPlatformChannelSpecifics = IOSNotificationDetails();
  return NotificationDetails(
      androidPlatformChannelSpecifics, iOSPlatformChannelSpecifics);
}

Future _showNotification(
  FlutterLocalNotificationsPlugin notifications, {
  @required String title,
  @required String body,
  @required NotificationDetails type,
  int id = 0,
}) =>
    notifications.show(id, title, body, type);
