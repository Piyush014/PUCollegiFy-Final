import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dummy/Login/Authpage.dart';
import 'package:dummy/Notifications/firebase_api.dart';
import 'package:dummy/foodStores/providers/cart_provider.dart';
import 'package:dummy/minor%20screens/splash.dart';
import 'package:dummy/minor%20screens/userHomescreenBottomNavBar.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
enum Topic {
  events;
}
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  NotificationSettings settings = await messaging.requestPermission();
  if (settings.authorizationStatus == AuthorizationStatus.authorized) {
    print('Permission granted');
  } else {
    print('Permission denied');
  }
  await FirebaseMessaging.instance
      .setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,
  );


  FirebaseMessaging.instance.subscribeToTopic('events');
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  FirebaseMessaging.onMessage.listen((RemoteMessage message) {
    AndroidNotificationChannel channel = const AndroidNotificationChannel(
      'high_importance_channel', // id
      'High Importance Notifications', // title// description
      importance: Importance.max,
    );
    RemoteNotification? notification = message!.notification;
    AndroidNotification? android = message.notification?.android;
    if (notification != null && android != null) {
      flutterLocalNotificationsPlugin.show(
          notification.hashCode,
          notification.title,
          notification.body,
          NotificationDetails(
            android: AndroidNotificationDetails(
              channel.id,
              channel.name,
            ),
          ));
    }
  });

  // FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //   print('hii');
  //   RemoteNotification? notification = message.notification;
  //   AndroidNotification? android = message.notification?.android;
  //   AndroidNotificationChannel channel = AndroidNotificationChannel(
  //       Random.secure().nextInt(100000).toString(),
  //       'High Importance Notification',
  //       importance: Importance.max);
  //   // If `onMessage` is triggered with a notification, construct our own
  //   // local notification to show to users using the created channel.
  //   if (notification != null && android != null) {
  //     flutterLocalNotificationsPlugin.show(
  //         notification.hashCode,
  //         notification.title,
  //         notification.body,
  //         NotificationDetails(
  //           android: AndroidNotificationDetails(
  //             channel.id,
  //             channel.name,
  //             icon: android?.smallIcon,
  //             // other properties...
  //           ),
  //         ));
  //   }
  // });
  // Initialize notifications

  // await FirebaseApi().initNotification();
  // final FirebaseFirestore firestore = FirebaseFirestore.instance;
  // List<Map<String, dynamic>> cellData = [
  //   {
  //     'cellContact': '123456789',
  //     'cellDescription': 'xyz',
  //     'cellName': 'EDC',
  //     'cellImage': 'https://firebasestorage.googleapis.com/v0/b/dummy-proj-221a5.appspot.com/o/foodStores%2Fcr%40gmail.com%2Fcr.jpg?alt=media&token=e88fd78d-a80a-43f7-a8e5-742bdb431e25',
  //     'cellLocation': 'BBA Building',
  //     'cellWebsite': 'https://edc.paruluniversity.ac.in/',
  //     // Replace with the desired user_id
  //   },
  //
  //
  //   // Add more user data as needed
  // ];
  //
  // // Add each user data as a document with user_id as the document name
  // for (var cellData in cellData) {// Get the user_id
  //   await firestore.collection('Cell').doc().set(cellData);
  // }
  //
  // print('Documents added to Firestore with user_id as document name successfully.');

  runApp(MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => Cart())],
      child: const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {




  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      navigatorKey: GlobalContextService.navigatorKey,
      home: const Splash(),
    );
  }
}

class GlobalContextService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();
}
