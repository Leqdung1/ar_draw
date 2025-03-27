import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../analytics/analytics_util.dart';
import '../remote_config/remote_key_const.dart';
import '../remote_config/remote_services.dart';
import '../top_level_variable.dart';
import '../utils/extensions/num_ext.dart';
import 'ads_service.dart';
import 'ads_unit_id_const.dart';

enum BannerAdsStatus { loading, loaded, failed }

class RagnarokBannerAdsObject {
  final AdSize adSize;

  /// Whether the banner ad is at the bottom of the screen.
  /// Required for case banner ad is at the top of the screen to avoid overlap with the status bar.
  final bool isBottom;

  /// The screen name where the banner ad is displayed. Required for analytics.
  final String screen;

  /// The background color of the banner ad. Default is transparent.
  final Color backgroundColor;

  /// The border color of the banner ad. Default is black.
  final Color borderColor;

  /// The height of the banner ad. Required for fluid ad size.
  final double? height;

  /// The width of the banner ad. Default is infinity.
  final double? width;

  /// The condition to show the banner ad. Default is null as always show.
  final bool Function()? condition;

  final ValueChanged<BannerAdsStatus> onStatusChanged;

  RagnarokBannerAdsObject({
    this.adSize = AdSize.banner,
    this.isBottom = true,
    required this.screen,
    this.backgroundColor = Colors.transparent,
    this.borderColor = Colors.black,
    this.height,
    this.width,
    this.condition,
    required this.onStatusChanged,
  }) {
    assert(adSize != AdSize.fluid || (height != null && width != null)); // Nếu ad size là fluid thì cần có height và width
    status.addListener(() {
      onStatusChanged(status.value);
    });
  }

  ValueNotifier<BannerAdsStatus> status = ValueNotifier(BannerAdsStatus.failed);

  static String get _bannerAdUnitIdAndroid => isDebugMode
      ? AdsUnitIdConst.bannerAdUnitIdAndroidTest
      : RemoteService.getString(RemoteKeyConst.bannerAdUnitIdAndroid);

  static String get _bannerAdUnitIdIOS => isDebugMode
      ? AdsUnitIdConst.bannerAdUnitIdIOSTest
      : RemoteService.getString(RemoteKeyConst.bannerAdUnitIdIOS);

  static String get bannerAdUnitId =>
      Platform.isAndroid ? _bannerAdUnitIdAndroid : _bannerAdUnitIdIOS;

  BannerAd? _bannerAd;

  Future<void> load() async {
    if (Platform.isIOS) {
      return;
    }
    try {
      if (status.value == BannerAdsStatus.loading) {
        return;
      }
      status.value = BannerAdsStatus.loading;
      // Prevent loading multiple ads.
      Future.delayed(const Duration(milliseconds: 15000), () {
        if (status.value == BannerAdsStatus.loading) {
          status.value = BannerAdsStatus.failed;
        }
      });

      BannerAd ad = BannerAd(
        adUnitId: bannerAdUnitId,
        size: adSize,
        request: const AdRequest(
          httpTimeoutMillis: 15000,
        ),
        listener: BannerAdListener(
          onAdLoaded: (Ad ad) {  // load ad thành công
            _bannerAd = ad as BannerAd;
            status.value = BannerAdsStatus.loaded;
          },
          onAdFailedToLoad: (Ad ad, LoadAdError error) { 
            ad.dispose();
            _bannerAd = null;
            status.value = BannerAdsStatus.failed;
            if (AdsService.logConsole) {
              print('BannerAd failed to load: $error');
            } else {
              appLog.logError('BannerAd failed to load: $error');
            }
          },
          onAdImpression: (ad) {
            /// Log the banner ad impression event.
            AnalyticsUtil.logEvent(EventKeyConst.bannerImpression, {
              /// The screen name where the banner ad is displayed. if null, use the current screen.
              'screen': screen,
            });
          },
          onAdClicked: (ad) {
            /// Log the banner ad click event.
            AnalyticsUtil.logEvent(EventKeyConst.bannerClick, {
              /// The screen name where the banner ad is displayed. if null, use the current screen.
              'screen': screen,
            });
            AdsService.needToShowAds = false;
          },
        ),
      );
      await ad.load();
    } catch (e, s) {
      appLog.logError(e, stackTrace: s);
      _bannerAd = null;
      status.value = BannerAdsStatus.failed;
    }
  }

  void dispose() {
    try {
      _bannerAd?.dispose();
      _bannerAd = null;
    } catch (e) {
      appLog.logError(e);
    }
  }

  double get _height =>
      (height ?? adSize.height.toDouble()) +
      (!isBottom
          ? RagnarokNumExt.topPadding
          : isBottom && Platform.isIOS
              ? RagnarokNumExt.bottomPadding
              : 0.0);

  /// The width of the banner ad.
  double get _width => width ?? double.infinity;

  Widget build(
    BuildContext context, {
    Widget? placeholder,
  }) {
    if (condition != null && !condition!()) {
      return SafeArea(
        top: !isBottom,
        bottom: isBottom,
        left: false,
        right: false,
        child: const SizedBox(),
      );
    }
    return ValueListenableBuilder(
      valueListenable: AdsService.isPremium,
      builder: (context, isPremium, child) {
        if (isPremium) {
          return SafeArea(
            top: !isBottom,
            bottom: isBottom,
            left: false,
            right: false,
            child: const SizedBox(),
          );
        }
        return ValueListenableBuilder(
            valueListenable: status,
            builder: (context, status, child) {
              if (status == BannerAdsStatus.loading) {
                return Container(
                    width: _width,
                    height: _height,
                    decoration: BoxDecoration(
                      color: backgroundColor,
                      border: Border.all(color: borderColor),
                    ),
                    child: SafeArea(
                      bottom: isBottom,
                      top: !isBottom,
                      left: false,
                      right: false,
                      child: placeholder ??
                          const Center(
                            child: CircularProgressIndicator(),
                          ),
                    ));
              }
              if (_bannerAd == null || status == BannerAdsStatus.failed) {
                return SafeArea(
                  top: !isBottom,
                  bottom: isBottom,
                  left: false,
                  right: false,
                  child: const SizedBox(),
                );
              }
              return Container(
                width: _width,
                height: _height,
                decoration: BoxDecoration(
                  color: backgroundColor,
                  border: Border.all(color: borderColor),
                ),
                child: SafeArea(
                  bottom: isBottom,
                  top: !isBottom,
                  left: false,
                  right: false,
                  child: AdWidget(ad: _bannerAd!),
                ),
              );
            });
      }, 
    );
  }
}
