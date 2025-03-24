import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:ragnarok_flutter/ads/ads_service.dart';
import 'package:ragnarok_flutter/ads/ads_unit_id_const.dart';
import 'package:ragnarok_flutter/analytics/analytics_util.dart';
import 'package:ragnarok_flutter/local_storage/ragnarok_local_storage.dart';
import 'package:ragnarok_flutter/local_storage/ragnarok_local_storage_key.dart';
import 'package:ragnarok_flutter/navigation/app_router.dart';
import 'package:ragnarok_flutter/remote_config/remote_services.dart';
import 'package:ragnarok_flutter/top_level_variable.dart';

import '../remote_config/remote_key_const.dart';

class RagnarokIntersAds {
  static int _lastTimeShowIntersAd = 0;

  static int get _countToShowIntersAd =>
      RagnarokLocalStorage.getInt(
          RagnarokLocalStorageKey.countToShowInterstitialAd) ??
      0;

  static String get _intersAdUnitIdAndroid => isDebugMode
      ? AdsUnitIdConst.interstitialAdUnitIdAndroidTest
      : RemoteService.getString(RemoteKeyConst.interstitialAdUnitIdAndroid);

  static String get _intersAdUnitIdIOS => isDebugMode
      ? AdsUnitIdConst.interstitialAdUnitIdIOSTest
      : RemoteService.getString(RemoteKeyConst.interstitialAdUnitIdIOS);

  static String get intersAdUnitId =>
      Platform.isAndroid ? _intersAdUnitIdAndroid : _intersAdUnitIdIOS;

  static InterstitialAd? _interstitialAd;

  static bool get _canShowAds =>
      !AdsService.isPremium.value && !AdsService.isShowingAds;

  static void load() async {
    try {
      if (Platform.isIOS) {
        return;
      }
      if (_interstitialAd != null) {
        return;
      }
      await InterstitialAd.load(
        adUnitId: intersAdUnitId,
        request: AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {
            appLog.log('InterstitialAd loaded');
            _interstitialAd = ad;
            _interstitialAd!.setImmersiveMode(true);
          },
          onAdFailedToLoad: (LoadAdError error) {
            if (AdsService.logConsole) {
              print('InterstitialAd failed to load: $error');
            } else {
              appLog.logError('InterstitialAd failed to load: $error');
            }
            _interstitialAd = null;
          },
        ),
      );
    } catch (e, s) {
      if (AdsService.logConsole) {
        print('InterstitialAd failed to load: $e, StackTrace: $s');
      } else {
        appLog.logError('InterstitialAd failed to load: $e, StackTrace: $s');
      }
      _interstitialAd = null;
    }
  }

  static void show(
      {bool Function()? condition, String? screen, bool autoLoad = true}) {
    void _load() {
      if (Platform.isIOS) {
        return;
      }
      if (autoLoad) {
        load();
      }
    }

    if (condition != null && !condition()) return;
    if (!_canShowAds) return;
    RagnarokLocalStorage.setInt(
        RagnarokLocalStorageKey.countToShowInterstitialAd,
        _countToShowIntersAd + 1);
    if (_countToShowIntersAd <
        RemoteService.getInt(RemoteKeyConst.sessionNumberToShowIntersAd)) {
      return;
    }
    if (DateTime.now().millisecondsSinceEpoch - _lastTimeShowIntersAd <
        RemoteService.getInt(RemoteKeyConst.interstitialShowAdInterval) *
            1000) {
      return;
    }
    if (_interstitialAd == null) {
      _load();
      return;
    }
    try {
      AdsService.showOverlayEntry();
    } catch (e) {}
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (InterstitialAd ad) {
        _interstitialAd = null;
        try {
          AdsService.removeOverlayEntry();
        } catch (e) {}
        RagnarokLocalStorage.setInt(
            RagnarokLocalStorageKey.countToShowInterstitialAd, 0);
        AdsService.isShowingAds = false;
        _lastTimeShowIntersAd = DateTime.now().millisecondsSinceEpoch;
        AdsService.needToShowAds = false;
        _load();
      },
      onAdWillDismissFullScreenContent: (InterstitialAd ad) {
        _interstitialAd = null;
        try {
          AdsService.removeOverlayEntry();
        } catch (e) {}
        RagnarokLocalStorage.setInt(
            RagnarokLocalStorageKey.countToShowInterstitialAd, 0);
        AdsService.isShowingAds = false;
        _lastTimeShowIntersAd = DateTime.now().millisecondsSinceEpoch;
        AdsService.needToShowAds = false;
        _load();
      },
      onAdFailedToShowFullScreenContent: (InterstitialAd ad, AdError error) {
        appLog
            .logError('InterstitialAd failed to show: $error, screen: $screen');
        ad.dispose();
        try {
          AdsService.removeOverlayEntry();
        } catch (e) {}
        _interstitialAd = null;
        AdsService.isShowingAds = false;
        _load();
      },
      onAdShowedFullScreenContent: (InterstitialAd ad) {
        AdsService.isShowingAds = true;
        AdsService.needToShowAds = false;
      },
      onAdImpression: (Ad ad) {
        try {
          AnalyticsUtil.logEvent(EventKeyConst.interstitialImpression, {
            'screen': screen ?? globalContext?.appNavigator.currentRoute ?? '',
          });
        } catch (e) {}
      },
      onAdClicked: (Ad ad) {
        try {
          AnalyticsUtil.logEvent(EventKeyConst.interstitialClick, {
            'screen': screen ?? globalContext?.appNavigator.currentRoute ?? '',
          });
        } catch (e) {}
        AdsService.isShowingAds = false;
        AdsService.needToShowAds = false;
      },
    );
    _interstitialAd!.show();
  }
}
