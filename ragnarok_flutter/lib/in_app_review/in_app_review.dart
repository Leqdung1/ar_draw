import 'dart:io';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:in_app_review/in_app_review.dart';
import 'package:ragnarok_flutter/local_storage/ragnarok_local_storage.dart';
import 'package:ragnarok_flutter/remote_config/remote_key_const.dart';
import 'package:ragnarok_flutter/remote_config/remote_services.dart';
import 'package:ragnarok_flutter/throw_crash.dart';
import 'package:ragnarok_flutter/top_level_variable.dart';
import 'package:ragnarok_flutter/utils/extensions/string_ext.dart';
import 'package:url_launcher/url_launcher.dart';

class RagnarokInAppReview {
  static InAppReview _inAppReview = InAppReview.instance;

  static bool _initialized = false;

  static String appStoreId = '';

  static String microsoftStoreId = '';

  static bool testMode = false;

  static void initialize({
    bool testMode = false,
    String appStoreId = '',
    String microsoftStoreId = '',
  }) {
    RagnarokInAppReview.testMode = testMode;
    if (Platform.isIOS && !testMode && appStoreId.isBlank) {
      final url = RemoteService.getString(RemoteKeyConst.appStoreLink);
      if (url.isBlank) {
        ThrowCrash.crash('App store link is not found. Please provide [appStoreId] or setup [app store link] in remote config.');
      }
      RagnarokInAppReview.appStoreId = url.split('/').last;
    }
    RagnarokInAppReview.appStoreId = appStoreId;
    if (_initialized) {
      return;
    }
    _initialized = true;
  }

  static void requestReview() async {
    if (!_initialized) {
      ThrowCrash.crash('RagnarokInAppReview is not initialized. Please call initialize() first.');
      return;
    }
    final isAvailable = await _inAppReview.isAvailable();
    if (isAvailable) {
      await _inAppReview.requestReview();
    }
    RagnarokLocalStorage.reviewStatus = true;
  }

  static void openStoreListing() async {
    if (!_initialized) {
      ThrowCrash.crash('RagnarokInAppReview is not initialized. Please call initialize() first.');
      return;
    }
    if (testMode) {
      if (Platform.isAndroid) {
        await launchUrl(Uri.parse(
            'https://play.google.com/store/apps/details?id=com.godhitech.diary.journal.lock.mood'));
      } else if (Platform.isIOS) {
        await launchUrl(Uri.parse(
            'https://apps.apple.com/vn/app/noteme-easy-notepad-notebook/id6502438865'));
      }
    }
    await _inAppReview.openStoreListing(
      appStoreId: appStoreId,
      microsoftStoreId: microsoftStoreId,
    );
  }
}
