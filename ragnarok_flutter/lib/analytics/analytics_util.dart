import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:ragnarok_flutter/top_level_variable.dart';
import 'package:flutter/foundation.dart';

part 'event_key_const.dart';

class AnalyticsUtil {
  static late FirebaseAnalytics analytics;

  static void logEvent(String eventName,
      [Map<String, Object>? params = const {}]) {
    if (kDebugMode) {
      appLog.log('logEvent: $eventName, params: $params',
          name: 'Ragnarok Analytics Debug');
      return;
    }
    appLog.log('logEvent: $eventName, params: $params',
        name: 'Ragnarok Analytics');
    if (params?.isNotEmpty == true) {
      analytics.logEvent(name: eventName, parameters: {
        for (final key in params!.keys)
          key: params[key] == null ? '' : params[key] as Object,
      });
    } else {
      analytics.logEvent(name: eventName);
    }
  }

  static void logScreen(
      {required String screenName,
      String? previousScreenName,
      Map<String, dynamic>? params}) {
    logEvent('screen_view', {
      'screen_name': screenName,
      if (previousScreenName != null)
        'previous_screen_name': previousScreenName,
      ...?params,
    });
  }

  static void logScreenEntry(String screenName,
      {Map<String, dynamic>? params, String? previousScreenName}) {
    final int count = countPerSession[screenName] ?? 1;
    countPerSession[screenName] = count + 1;
    logEvent(
      'screen_entry',
      {
        'screen_name': screenName,
        if (previousScreenName != null)
          'previous_screen_name': previousScreenName,
        'count': count,
        ...?params,
      },
    );
  }
}
