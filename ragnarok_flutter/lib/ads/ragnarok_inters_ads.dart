import 'dart:io';
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
  static int _lastTimeShowIntersAd = 0;  // thời gian lần cuối show quảng cáo 

  static int get _countToShowIntersAd =>
      RagnarokLocalStorage.getInt(
          RagnarokLocalStorageKey.countToShowInterstitialAd) ??
      0;

  static String get _intersAdUnitIdAndroid => isDebugMode 
      ? AdsUnitIdConst.interstitialAdUnitIdAndroidTest // Nếu chạy ở debugMode thì dùng id test 
      : RemoteService.getString(RemoteKeyConst.interstitialAdUnitIdAndroid);  

  static String get _intersAdUnitIdIOS => isDebugMode
      ? AdsUnitIdConst.interstitialAdUnitIdIOSTest // Nếu chạy ở debugMode thì dùng id test 
      : RemoteService.getString(RemoteKeyConst.interstitialAdUnitIdIOS);

  static String get intersAdUnitId => // Lấy id của ads theo nền tảng
      Platform.isAndroid ? _intersAdUnitIdAndroid : _intersAdUnitIdIOS;  

  static InterstitialAd? _interstitialAd;  

  static bool get _canShowAds => // check nếu người dùng đã mua premium và đã show ads thì ko hiển thị ads
      !AdsService.isPremium.value && !AdsService.isShowingAds;

  // Load Ads
  static void load() async {
    try {
      if (Platform.isIOS) {  // Chỉ hiện thị ở Android nếu là IOS thì thoát ngay lập tức
        return;
      }
      if (_interstitialAd != null) {  // Nếu đã hiện quảng cáo thì ko hiện nữa 
        return; 
      }
      // A full-screen interstitial ad for the Google Mobile Ads Plugin.
      await InterstitialAd.load(  // Tải quảng cáo
        adUnitId: intersAdUnitId, // Lấy id quảng cáo
        request: AdRequest(),  // Yêu cầu quảng cáo
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: (InterstitialAd ad) {  // Tải quảng cáo thành công
            appLog.log('InterstitialAd loaded');
            _interstitialAd = ad;
            _interstitialAd!.setImmersiveMode(true); // Hiển thị ads toàn màn hình (che cả thanh status bar) chỉ hiện ở android
          },
          onAdFailedToLoad: (LoadAdError error) {  // Tải quảng cáo thất bại
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


  // Show quảng cáo
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

    if (condition != null && !condition()) return; // điều kiện truyền từ ngoài vào 
    if (!_canShowAds) return; // nếu đã mua premium or đã show ads thì ko show nữa 
    RagnarokLocalStorage.setInt(
        RagnarokLocalStorageKey.countToShowInterstitialAd, // đếm số lần show ads
        _countToShowIntersAd + 1);
    if (_countToShowIntersAd <
        RemoteService.getInt(RemoteKeyConst.sessionNumberToShowIntersAd)) {
      return; 
    }
    if (DateTime.now().millisecondsSinceEpoch - _lastTimeShowIntersAd <      // Check thời gian đủ lâu để show quảng cáo 
        RemoteService.getInt(RemoteKeyConst.interstitialShowAdInterval) *
            1000) {
      return;
    }
    if (_interstitialAd == null) { // Không có quảng cáo
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
    _interstitialAd!.show(); // show ads
  }
}
