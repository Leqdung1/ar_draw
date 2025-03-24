import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:ragnarok_flutter/ads/ads_service.dart';
import 'package:ragnarok_flutter/analytics/analytics_util.dart';
import 'package:ragnarok_flutter/navigation/routing.dart';
import 'package:ragnarok_flutter/top_level_variable.dart';

import '../remote_config/remote_key_const.dart';
import '../remote_config/remote_services.dart';
import 'ads_unit_id_const.dart';

class RagnarokRewardAds {
  static String get _rewardAdUnitIdAndroid => isDebugMode
      ? AdsUnitIdConst.rewardedAdUnitIdAndroidTest
      : RemoteService.getString(RemoteKeyConst.rewardedAdUnitIdAndroid);

  static String get _rewardAdUnitIdIOS => kDebugMode
      ? AdsUnitIdConst.rewardedAdUnitIdIOSTest
      : RemoteService.getString(RemoteKeyConst.rewardedAdUnitIdIOS);

  static String get rewardAdUnitId =>
      Platform.isAndroid ? _rewardAdUnitIdAndroid : _rewardAdUnitIdIOS;

  static RewardedAd? _rewardedAd;

  static ValueNotifier<bool> isLoaded = ValueNotifier(false);

  static Future<void> load() async {
    if (Platform.isIOS) {
      return;
    }
    try {
      if (isLoaded.value) return;
      RewardedAd.load(
          adUnitId: rewardAdUnitId,
          request: AdRequest(),
          rewardedAdLoadCallback: RewardedAdLoadCallback(
            onAdLoaded: (RewardedAd ad) {
              _rewardedAd = ad;
              _rewardedAd!.setImmersiveMode(true);
              appLog.log('RewardedAd loaded');
              isLoaded.value = true;
            },
            onAdFailedToLoad: (LoadAdError error) {
              if (AdsService.logConsole) {
                print('RewardedAd failed to load: $error');
              } else {
                appLog.logError('RewardedAd failed to load: $error');
              }
              _rewardedAd = null;
              isLoaded.value = false;
            },
          ));
    } catch (e) {
      if (AdsService.logConsole) {
        print('RewardedAd failed to load: $e');
      } else {
        appLog.logError('RewardedAd failed to load: $e');
      }
      _rewardedAd = null;
      isLoaded.value = false;
    }
  }

  static void show({
    bool Function()? condition,
    Function? onAdFailedToLoad,
    String? screen,
    required void Function(AdWithoutView ad, RewardItem reward)
        onUserEarnedReward,
  }) {
    if (_rewardedAd == null) {
      onAdFailedToLoad?.call();
      return;
    }
    if (condition != null && !condition()) return;
    if (!isLoaded.value) {
      load();
      return;
    }
    if (AdsService.isShowingAds) return;
    try {
      AdsService.showOverlayEntry();
    } catch (e) {}
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdShowedFullScreenContent: (RewardedAd ad) {
        AdsService.isShowingAds = true;
      },
      onAdDismissedFullScreenContent: (RewardedAd ad) {
        ad.dispose();
        _rewardedAd = null;
        AdsService.isShowingAds = false;
        try {
          AdsService.removeOverlayEntry();
        } catch (e) {}
        load();
      },
      onAdFailedToShowFullScreenContent: (RewardedAd ad, AdError error) {
        appLog.logError('RewardedAd failed to show: $error');
        ad.dispose();
        _rewardedAd = null;
        AdsService.isShowingAds = false;
        try {
          AdsService.removeOverlayEntry();
        } catch (e) {}
        load();
      },
      onAdImpression: (RewardedAd ad) {
        try {
          AnalyticsUtil.logEvent(EventKeyConst.rewardedImpression, {
            'screen': screen ?? globalContext?.appNavigator.currentRoute ?? '',
          });
        } catch (e) {}
      },
      onAdClicked: (RewardedAd ad) {
        try {
          AnalyticsUtil.logEvent(EventKeyConst.rewardedClick, {
            'screen': screen ?? globalContext?.appNavigator.currentRoute ?? '',
          });
        } catch (e) {}
      },
    );
    _rewardedAd!.show(onUserEarnedReward: onUserEarnedReward);
  }
}
