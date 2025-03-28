import 'package:flutter/material.dart';

import 'package:test_ar/local_notification.dart';

class NotifiScreen extends StatelessWidget {
  const NotifiScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: LocalNotification.showNotificationOnshot,
            child: Icon(Icons.notifications),
          ),
          ElevatedButton(
            onPressed: LocalNotification.showNotificationOnshot1,
            child: Icon(Icons.notifications),
          ),
        ],
      ),
    );
  }
}
