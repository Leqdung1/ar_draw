// import 'dart:io';

// import 'package:device_info_plus/device_info_plus.dart';
// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:ragnarok_flutter/ads/ads_service.dart';
// import 'package:ragnarok_flutter/permission/permission_utils.dart';
// import 'package:ragnarok_flutter/top_level_variable.dart';
// import 'package:timezone/timezone.dart';

// @pragma('vm:entry-point')
// void onDidReceiveNotificationResponse(NotificationResponse response) {
//   // AdsService.needToShowAds = true;
// }

// @pragma('vm:entry-point')
// void onDidReceiveBackgroundNotificationResponse(NotificationResponse response) {
//   // AdsService.needToShowAds = true;
// }

// class LocalNotification {
//   static final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//       FlutterLocalNotificationsPlugin();

//   static Future<void> initialize(String icon) async {
//     final bool isGranted = await requestNotiPermission();
//     appLog.log('isGranted: $isGranted');
//     if (!isGranted) {
//       return;
//     }
//     final AndroidInitializationSettings initializationSettingsAndroid =
//         AndroidInitializationSettings(icon);
//     final DarwinInitializationSettings initializationSettingsIOS =
//         DarwinInitializationSettings();

//     final InitializationSettings initializationSettings =
//         InitializationSettings(
//       android: initializationSettingsAndroid,
//       iOS: initializationSettingsIOS,
//     );

//     await flutterLocalNotificationsPlugin.initialize(
//       initializationSettings,
//       onDidReceiveNotificationResponse: onDidReceiveNotificationResponse,
//       onDidReceiveBackgroundNotificationResponse:
//           onDidReceiveBackgroundNotificationResponse,
//     );
//   }

//   static Future<bool> requestNotiPermission() async {
//     if (Platform.isAndroid) {
//       final deviceInfo = await DeviceInfoPlugin().androidInfo;
//       bool isGranded = true;
//       if (deviceInfo.version.sdkInt <= 100) {
//         // AdsService.needToShowAds = false;
//         await PermissionUtils.permissionHandler(
//           permission: Permission.notification,
//           onDenied: () {
//             isGranded = false;
//           },
//           onGranted: () {
//             isGranded = true;
//           },
//         );
//       }
//       if (!isGranded) {
//         return false;
//       }
//       return true;
//     }
//     bool isGranded = true;
//     // AdsService.needToShowAds = false;
//     await PermissionUtils.permissionHandler(
//       permission: Permission.notification,
//       onDenied: () {
//         isGranded = false;
//       },
//       onGranted: () {
//         isGranded = true;
//       },
//     );
//     return isGranded;
//   }

//   Future<bool> requestScheduleExactAlarm() async {
//     bool isGranted = false;
//     final deviceInfo = await DeviceInfoPlugin().androidInfo;
//     if (deviceInfo.version.sdkInt <= 32) {
//       return true;
//     }
//     await PermissionUtils.permissionHandler(
//       permission: Permission.scheduleExactAlarm,
//       onGranted: () {
//         isGranted = true;
//       },
//       onDenied: () {
//         isGranted = false;
//       },
//     );
//     return isGranted;
//   }

//   Future<void> showNotification({
//     required int id,
//     required String title,
//     required String body,
//     required String payload,
//   }) async {
//     final AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//       'ragnarok_flutter',
//       'ragnarok_flutter',
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//     final NotificationDetails platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);
//     await flutterLocalNotificationsPlugin.show(
//       id,
//       title,
//       body,
//       platformChannelSpecifics,
//       payload: payload,
//     );
//   }

//   Future<void> cancelNotification(int id) async {
//     await flutterLocalNotificationsPlugin.cancel(id);
//   }

//   Future<void> cancelAllNotification() async {
//     await flutterLocalNotificationsPlugin.cancelAll();
//   }

//   Future<void> schedule({
//     required int id,
//     required String title,
//     required String body,
//     required String payload,
//     required TZDateTime scheduledDateTime,
//     DateTimeComponents? matchDateTimeComponents,
//   }) async {
//     final AndroidNotificationDetails androidPlatformChannelSpecifics =
//         AndroidNotificationDetails(
//       'ragnarok_flutter',
//       'ragnarok_flutter',
//       importance: Importance.max,
//       priority: Priority.high,
//     );
//     final NotificationDetails platformChannelSpecifics =
//         NotificationDetails(android: androidPlatformChannelSpecifics);
//     await flutterLocalNotificationsPlugin.zonedSchedule(
//       id,
//       title,
//       body,
//       scheduledDateTime,
//       platformChannelSpecifics,
//       uiLocalNotificationDateInterpretation:
//           UILocalNotificationDateInterpretation.absoluteTime,
//       matchDateTimeComponents:
//           matchDateTimeComponents ?? DateTimeComponents.dateAndTime,
//       payload: payload,
//     );
//   }
// }
