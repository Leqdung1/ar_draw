import 'package:flutter/material.dart';

import 'package:test_ar/local_notification.dart';

class TestNoti extends StatelessWidget {
  const TestNoti({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () async {
              await LocalNotification.showNotificationSchedule();
            },
            child: Icon(Icons.notifications),
          ),
          ElevatedButton(
            onPressed: () async {
              await LocalNotification.showNotificationScheduleWeek([
                DateTime.monday,
                DateTime.tuesday,
                DateTime.thursday,
              ]);
            },
            child: Icon(Icons.notifications),
          ),
        ],
      ),
    );
  }
}
