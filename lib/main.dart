import 'package:flutter/material.dart';
import 'package:ragnarok_flutter/ads/ads_service.dart';
import 'package:ragnarok_flutter/ads/ragnarok_inters_ads.dart';
import 'package:ragnarok_flutter/ads/ragnarok_open_ads.dart';
import 'package:ragnarok_flutter/ragnarok_app/ragnarok_app.dart';
import 'package:ragnarok_flutter/ragnarok_flutter.dart';
import 'package:test_ar/local_notification.dart';
import 'package:test_ar/native_ads.dart';
import 'package:test_ar/router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await RagnarokFlutter.initialize();
  await LocalNotification.init();
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
