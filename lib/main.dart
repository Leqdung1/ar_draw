import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:home_widget/home_widget.dart';
import 'package:ragnarok_flutter/ads/ads_service.dart';
import 'package:ragnarok_flutter/ads/ragnarok_inters_ads.dart';
import 'package:ragnarok_flutter/ads/ragnarok_open_ads.dart';
import 'package:ragnarok_flutter/ragnarok_app/ragnarok_app.dart';
import 'package:ragnarok_flutter/ragnarok_flutter.dart';
import 'package:test_ar/notifications/background_service.dart';
import 'package:test_ar/notifications/local_notification.dart';
import 'package:test_ar/native_ads.dart';
import 'package:test_ar/router.dart';

// Lắng nghe các mesage khi ở trạng thái background
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message ${message.messageId}');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RagnarokFlutter.initialize();
  await LocalNotification.init();
  await Firebase.initializeApp();
  await initializeService();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  AdsService.initialize(
    loadAds: () {
      RagnarokIntersAds.load();
      RagnarokOpenAds.load();
      NativeAds.load();
    },
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RagnarokApp(
      initAppPageRoute: AppPageRouteExt.home(),
      debugShowCheckedModeBanner: false,
      themeMode: ThemeMode.light,
    );
  }
}
