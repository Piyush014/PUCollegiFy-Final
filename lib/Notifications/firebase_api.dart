import 'dart:io';
import 'dart:math';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

FirebaseMessaging messaging = FirebaseMessaging.instance;
final FlutterLocalNotificationsPlugin _flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

void initLocalNotifications(BuildContext context, RemoteMessage message) async {
  var androidInitializationSettings =
      const AndroidInitializationSettings('@mipmap/ic_launcher');
  var iosInitializationSettings = const DarwinInitializationSettings();

  var initializationSettings = InitializationSettings(
      android: androidInitializationSettings, iOS: iosInitializationSettings);
  await _flutterLocalNotificationsPlugin.initialize(initializationSettings,
      onDidReceiveNotificationResponse: (payload) {});
}

void firebaseInit(BuildContext context) {
  FirebaseMessaging.onMessage.listen((message) {

    if (Platform.isAndroid) {
      initLocalNotifications(context, message);
      showNotification(message);
    }
  });
}

Future<void> showNotification(RemoteMessage message) async {
  AndroidNotificationChannel channel = AndroidNotificationChannel(
      Random.secure().nextInt(100000).toString(),
      'High Importance Notification',
      importance: Importance.max);
  AndroidNotificationDetails androidNotificationDetails =
      AndroidNotificationDetails(channel.id.toString(), channel.name.toString(),
          channelDescription: 'channel description',
      importance: Importance.max,priority: Priority.high,ticker: 'ticker');

  NotificationDetails notificationDetails=NotificationDetails(android: androidNotificationDetails);
  _flutterLocalNotificationsPlugin.show(0, message.notification!.title.toString(), message.notification!.body.toString(), notificationDetails);
}
