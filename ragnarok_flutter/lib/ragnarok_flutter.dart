import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:ragnarok_flutter/analytics/analytics_util.dart';
import 'package:ragnarok_flutter/local_storage/ragnarok_local_storage.dart';
import 'package:ragnarok_flutter/top_level_variable.dart';

class RagnarokFlutter {
  static bool initialized = false;

  static Future<void> initialize(
      {List<AppLanguage>? defaultLanguage,
      FirebaseOptions? firebaseOptions}) async {
    WidgetsFlutterBinding.ensureInitialized();
    await RagnarokLocalStorage.initialize();
    // await RagnarokStringConst.initialize();
    final firebaseApp = await Firebase.initializeApp(options: firebaseOptions);
    AnalyticsUtil.analytics = FirebaseAnalytics.instanceFor(app: firebaseApp);
    initialized = true;
    if (defaultLanguage != null) {
      setDefaultLanguages(defaultLanguage);
    }
  }

  Future<String?> test() async {
    return 'test';
  }
}
