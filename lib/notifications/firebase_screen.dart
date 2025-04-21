import 'package:flutter/material.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:test_ar/notifications/local_notification.dart';

class FirebaseScreen extends StatefulWidget {
  @override
  _FirebaseScreenState createState() => _FirebaseScreenState();
}

class _FirebaseScreenState extends State<FirebaseScreen> {
  late FirebaseMessaging messaging;
  final _firebaseMessaging = FirebaseMessaging.instance;
  String? _fcmToken;

  @override
  void initState() {
    super.initState();
    messaging = FirebaseMessaging.instance;

    // Request permissions
    messaging.requestPermission();

    // Get FCM token
    messaging.getToken().then((token) {
      setState(() {
        _fcmToken = token;
      });
      print('FCM Token: $_fcmToken');
    });

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print('Message received: ${message.notification?.title}');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message.notification?.body ?? 'No message body'),
        ),
      );
      LocalNotification.showNotificationOnshotFireBase();
    });

    _firebaseMessaging.subscribeToTopic("Weather").then((_) {
      print("Subscribed to flutter_topic!");
    });
  }

  void _subscribeToTopic(String topic) {
    _firebaseMessaging.subscribeToTopic(topic).then((_) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Subscribed to $topic!")));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Firebase')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('FCM Token:', style: TextStyle(fontWeight: FontWeight.bold)),
            Text(_fcmToken ?? 'Fetching token...'),
            ElevatedButton(
              onPressed: () => _subscribeToTopic("Weather"),
              child: Text("Subscribe to Topic"),
            ),
          ],
        ),
      ),
    );
  }
}
