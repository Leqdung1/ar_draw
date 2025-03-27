import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:ragnarok_flutter/ads/ragnarok_inters_ads.dart';
import 'package:ragnarok_flutter/analytics/analytics_util.dart';

import '../event_bus/open_ads_event_bus.dart';
import '../local_storage/ragnarok_local_storage.dart';
import '../local_storage/ragnarok_local_storage_key.dart';
import '../remote_config/remote_key_const.dart';
import '../remote_config/remote_services.dart';
import '../top_level_variable.dart';
import 'ads_service.dart';
import 'ads_unit_id_const.dart';

class RagnarokOpenAds {
  static int _lastTimeShowOpenAds = 0;   // Lần cuối show ads
  static int get _countToShowAppOpenAds => // Số lần show ads
      RagnarokLocalStorage.getInt(
          RagnarokLocalStorageKey.countToShowAppOpenAd) ??
      0;

  static DateTime? _appOpenLoadTime; 

  static String get _openAdUnitIdAndroid => isDebugMode 
      ? AdsUnitIdConst.appOpenAdUnitIdAndroidTest
      : RemoteService.getString(RemoteKeyConst.appOpenAdUnitIdAndroid);

  static String get _openAdUnitIdIOS => isDebugMode
      ? AdsUnitIdConst.appOpenAdUnitIdIOSTest
      : RemoteService.getString(RemoteKeyConst.appOpenAdUnitIdIOS);

  static String get openAdUnitId =>  // id của open ads
      Platform.isAndroid ? _openAdUnitIdAndroid : _openAdUnitIdIOS;

  static bool get _canShowAds =>    // check điều kiện để show ads
      !AdsService.isPremium.value &&  
      !AdsService.isShowingAds &&
      AdsService.needToShowAds &&
      AppLifecycleReactor.appState == AppState.foreground;

  static bool get adAvailable => 
      _appOpenAd != null &&
      _appOpenLoadTime != null &&
      DateTime.now().difference(_appOpenLoadTime!).inMinutes < 4 * 60;

  static AppOpenAd? _appOpenAd;  /// A full-screen app open ad for the Google Mobile Ads Plugin.

  // sử dụng để kiểm tra xem đã show quảng cáo app open ở lần đầu vào app hay chưa
  static bool openAdShowedSplash = false;

  static OpenAdsEventBus openAdsEventBus = OpenAdsEventBus();

  // Tải ads
  static Future<void> load() async { 
    try {
      if (_appOpenAd != null) { // ad đã tải trc đó nên ko cần tải và thoát hàm 
        appLog.log('App open ads already loaded'); 
        return;
      }
      appLog.log('Loading app open ads'); 
      openAdsEventBus.fire('loading'); // phát trạng thái để toàn app biết đang load ad
      await AppOpenAd.load(  // open ad load
        adUnitId: openAdUnitId,
        request: const AdRequest(),
        adLoadCallback: AppOpenAdLoadCallback(
          onAdLoaded: (AppOpenAd ad) { // load ad thành công
            appLog.log('App open ads loaded');
            _appOpenLoadTime = DateTime.now(); // gán tgian tải quảng cáo bằng tgian hiện tại
            _appOpenAd = ad;  
            // _appOpenAd!.setImmersiveMode(true);
            openAdsEventBus.fire('loaded_splash');
            if (openAdShowedSplash != true) {
              openAdsEventBus.fire('loaded');  // thông báo cho toàn app biết đang load ad
            }
          },
          onAdFailedToLoad: (LoadAdError error) { // Load ads failed
            openAdsEventBus.fire('failed');
            if (AdsService.logConsole) {
              print('AppOpenAd failed to load: $error');
            } else {
              appLog.logError('AppOpenAd failed to load: $error');
            }
            AdsService.removeOverlayEntry();   
            _appOpenAd = null;
            openAdShowedSplash = true;
          },
        ),
      );
    } catch (e, s) {
      openAdsEventBus.fire('failed');
      appLog.logError('AppOpenAd failed to load: $e');
      AdsService.removeOverlayEntry();
      _appOpenAd = null;
      openAdShowedSplash = true;
    }
  }


  // show ad
  static void show({bool fromSplash = false, bool Function()? condition}) {
    try {
      // check các điều kiện để ko show ads
      if (condition != null && !condition()) return;
      if (!_canShowAds) return;
      appLog.log(
          'Show app open ads, from: ${fromSplash ? 'splash' : 'background'}');
      RagnarokLocalStorage.setInt(RagnarokLocalStorageKey.countToShowAppOpenAd,
          _countToShowAppOpenAds + 1);
      if (_countToShowAppOpenAds <
          RemoteService.getInt(RemoteKeyConst.sessionNumberToShowAppOpenAd))
        return;
      if (DateTime.now().millisecondsSinceEpoch - _lastTimeShowOpenAds <
          RemoteService.getInt(RemoteKeyConst.appOpenShowAdInterval) * 1000)
        return;
      if (_appOpenAd == null) {
        load();
        return;
      }
      if (!adAvailable) return;
      AdsService.isShowingAds = true;
      try {
        AdsService.showOverlayEntry();
      } catch (e) {}

      // show ad
      _appOpenAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          try {
            openAdsEventBus.fire('dismissed');
            appLog.log('AppOpenAd dismissed');
            try {
              AdsService.removeOverlayEntry();
            } catch (e) {}
            RagnarokLocalStorage.setInt(
                RagnarokLocalStorageKey.countToShowAppOpenAd, 0);
            AdsService.isShowingAds = false;
            _lastTimeShowOpenAds = DateTime.now().millisecondsSinceEpoch;
            openAdShowedSplash = true;
            ad.dispose();
            _appOpenAd = null;
            appLog.log('App open ads disposed');
          } catch (e, s) {
            appLog.logError(e, stackTrace: s);
          }
        },
        onAdWillDismissFullScreenContent: (ad) { // for only ios
          openAdsEventBus.fire('will_dismiss');
          try {
            AdsService.removeOverlayEntry();
          } catch (e) {}
          RagnarokLocalStorage.setInt(
              RagnarokLocalStorageKey.countToShowAppOpenAd, 0);
          AdsService.isShowingAds = false;
          _lastTimeShowOpenAds = DateTime.now().millisecondsSinceEpoch;
          openAdShowedSplash = true;
          ad.dispose();
          _appOpenAd = null;
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          openAdsEventBus.fire('failed');
          appLog.logError('App Open Ad failed to show: $error');
          ad.dispose();
          try {
            AdsService.removeOverlayEntry();
          } catch (e) {}
          _appOpenAd = null;
          AdsService.isShowingAds = false;
          openAdShowedSplash = true;
          if (fromSplash) {
            RagnarokIntersAds.show();
          }
        },
        onAdShowedFullScreenContent: (ad) {
          openAdsEventBus.fire('showed');
          appLog.log('AppOpenAd showed');
          AdsService.isShowingAds = true;
          openAdShowedSplash = true;
        },
        onAdImpression: (ad) {
          openAdsEventBus.fire('impression');
          appLog.log('AppOpenAd impression');
          AnalyticsUtil.logEvent(EventKeyConst.appOpenImpression, {
            'from': fromSplash ? 'splash' : 'background',
          });
          openAdShowedSplash = true;
        },
        onAdClicked: (ad) {
          openAdsEventBus.fire('clicked');
          AnalyticsUtil.logEvent(EventKeyConst.appOpenClick, {
            'from': fromSplash ? 'splash' : 'background',
          });
          openAdShowedSplash = true;
        },
      );
      _appOpenAd!.show();
    } catch (e, s) {
      appLog.logError(e, stackTrace: s);
      try {
        AdsService.removeOverlayEntry();
      } catch (e) {}
      AdsService.isShowingAds = false;
    }
  }
}

class AppLifecycleReactor {
  AppLifecycleReactor();

  static AppState appState = AppState.foreground;

  void lifeCycleChange() {
    AppStateEventNotifier.startListening();
    AppStateEventNotifier.appStateStream
        .forEach((state) => _onAppStateChanged(state));
  }

  void _onAppStateChanged(AppState state) {
    appLog.log('App state changed: $state');
    appState = state;
    if (state == AppState.foreground) {
      if (AdsService.needToShowAds) {
        RagnarokOpenAds.show();
      } else {
        AdsService.needToShowAds = true;
      }
    } else {
      RagnarokOpenAds.load();
    }
  }
}
