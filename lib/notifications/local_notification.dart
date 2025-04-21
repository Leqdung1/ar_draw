import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_timezone/flutter_timezone.dart';
import 'package:ragnarok_flutter/top_level_variable.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

@pragma('vm:entry-point')
void notificationTapBackground(NotificationResponse notificationResponse) {
  // ignore: avoid_print
  print(
    'notification(${notificationResponse.id}) action tapped: '
    '${notificationResponse.actionId} with'
    ' payload: ${notificationResponse.payload}',
  );
  if (notificationResponse.input?.isNotEmpty ?? false) {
    // ignore: avoid_print
    print(
      'notification action tapped with input: ${notificationResponse.input}',
    );
  }
}

class LocalNotification {
  static FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    const InitializationSettings initializationSettings =
        InitializationSettings(android: initializationSettingsAndroid);
    await _configureLocalTimeZone();
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
      onDidReceiveNotificationResponse: notificationTapBackground,
    );
    await showNotificationScheduleWeek([
      DateTime.monday,
      DateTime.tuesday,
      DateTime.thursday,
    ]);
    await showNotificationOnshotFireBase();
    await showNotificationOnshot();
    await showNotificationOnshot1();
  }

  static Future<void> _configureLocalTimeZone() async {
    tz.initializeTimeZones();
    final String timeZoneName = await FlutterTimezone.getLocalTimezone();
    tz.setLocalLocation(tz.getLocation(timeZoneName));
  }

  static Future<bool?> requestPermission() async {
    final permission =
        await flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
              AndroidFlutterLocalNotificationsPlugin
            >()
            ?.requestNotificationsPermission();
    return permission;
  }

  static Future<void> showNotificationSchedule() async {
    try {
      final permission = await requestPermission();
      if (permission != false) {
        final alarmPermission =
            await flutterLocalNotificationsPlugin
                .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin
                >()
                ?.requestExactAlarmsPermission();
        if (alarmPermission == false) {
          return;
        }
      }
      final now = tz.TZDateTime.now(tz.local);
      final time = now.add(const Duration(seconds: 10));
      await flutterLocalNotificationsPlugin.zonedSchedule(
        888,
        'Test Scheduled Notification',     
        '123456',
        time,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'your_channel_id',
            'your_channel_name',
            channelDescription: 'your channel description',
          ),
        ),
        uiLocalNotificationDateInterpretation:
            UILocalNotificationDateInterpretation.absoluteTime,
        androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
        matchDateTimeComponents: DateTimeComponents.time,
      );
      appLog.log(
        'Scheduling notification at ${time.toIso8601String()} ${tz.local}',
      );
    } catch (e) {
      print(e);
    }
  }

  static Future<void> showNotificationOnshot() async {
    try {
      await requestPermission();
      const androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your_channel_id',
        'your_channel_name',
        channelDescription: 'your_channel_description',
        importance: Importance.high,
        priority: Priority.high,
        ticker: 'ticker',
      );

      const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
      );

      await flutterLocalNotificationsPlugin.show(
        0,
        'i am dung',
        'test notification',
        platformChannelSpecifics,
      );
    } catch (e) {
      print(e);
    }
  }

  static Future<void> showNotificationOnshot1() async {
    await requestPermission();
    const androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'your_channel_id',
      'your_channel_name',
      channelDescription: 'your_channel_description',
      importance: Importance.min,
      priority: Priority.high,
      ticker: 'ticker',
    );

    const NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    await flutterLocalNotificationsPlugin.show(
      0,
      'i dung',
      'test notification 123',
      platformChannelSpecifics,
    );
  }

  static Future<void> showNotificationOnshotFireBase() async {
    try {
      await requestPermission();
      const androidPlatformChannelSpecifics = AndroidNotificationDetails(
        'your_channel_id',
        'your_channel_name',
        channelDescription: 'your_channel_description',
        importance: Importance.high,
        priority: Priority.high,
        ticker: 'ticker',
      );

      const NotificationDetails platformChannelSpecifics = NotificationDetails(
        android: androidPlatformChannelSpecifics,
      );

      await flutterLocalNotificationsPlugin.show(
        745,
        'testttttttttttt',
        '4234234rwsfdff',
        platformChannelSpecifics,
        payload: '12345231232',
      );
    } catch (e) {
      print(e);
    }
  }

  static Future<void> showNotificationScheduleWeek(final List<int> days) async {
    try {
      final permission = await requestPermission();
      if (permission != false) {
        final alarmPermission =
            await flutterLocalNotificationsPlugin
                .resolvePlatformSpecificImplementation<
                  AndroidFlutterLocalNotificationsPlugin
                >()
                ?.requestExactAlarmsPermission();
        if (alarmPermission == false) {
          return;
        }
      }

      final now = tz.TZDateTime.now(tz.local);

      for (final int day in days) {
        tz.TZDateTime time = now;
        while (time.weekday != day) {
          time = time.add(const Duration(days: 1));
        }
        await flutterLocalNotificationsPlugin.zonedSchedule(
          day,
          'Scheduled Notification $day',
          '12345632452323423421212',
          time,
          const NotificationDetails(
            android: AndroidNotificationDetails(
              'your_channel_id',
              'your_channel_name',
              channelDescription: 'your channel description',
            ),
          ),
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime,
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          matchDateTimeComponents: DateTimeComponents.dayOfMonthAndTime,
        );

        appLog.log('Scheduling notification at $time $day');
      }
    } catch (e) {
      print(e);
    }
  }
}
