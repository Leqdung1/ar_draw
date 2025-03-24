import 'dart:async';
import 'dart:io';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:ragnarok_flutter/ads/ads_unit_id_const.dart';
import 'package:ragnarok_flutter/analytics/analytics_util.dart';
import 'package:ragnarok_flutter/navigation/routing.dart';
import 'package:ragnarok_flutter/remote_config/remote_services.dart';
import 'package:ragnarok_flutter/top_level_variable.dart';
import 'package:ragnarok_flutter/utils/extensions/num_ext.dart';

import '../remote_config/remote_key_const.dart';
import 'ads_service.dart';

@Deprecated(
    'This class will be removed in the future. Use RagnarokBannerAdsObject instead.')
class RagnarokBannerAds extends StatefulWidget {
  const RagnarokBannerAds({
    this.adSize = AdSize.banner,
    this.isBottom = true,
    this.screen,
    this.backgroundColor = Colors.transparent,
    this.borderColor = Colors.black,
    this.height,
    this.width,
    this.condition,
    super.key,
  }) : assert(adSize != AdSize.fluid || (height != null && width != null));

  /// The size of the banner ad.
  final AdSize adSize;

  /// Whether the banner ad is at the bottom of the screen.
  /// Required for case banner ad is at the top of the screen to avoid overlap with the status bar.
  final bool isBottom;

  /// The screen name where the banner ad is displayed. Required for analytics.
  final String? screen;

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

  @override
  State<RagnarokBannerAds> createState() => _RagnarokBannerAdsState();
}

class _RagnarokBannerAdsState extends State<RagnarokBannerAds> {
  static String get _bannerAdUnitIdAndroid => isDebugMode
      ? AdsUnitIdConst.bannerAdUnitIdAndroidTest
      : RemoteService.getString(RemoteKeyConst.bannerAdUnitIdAndroid);

  static String get _bannerAdUnitIdIOS => isDebugMode
      ? AdsUnitIdConst.bannerAdUnitIdIOSTest
      : RemoteService.getString(RemoteKeyConst.bannerAdUnitIdIOS);

  static String get bannerAdUnitId =>
      Platform.isAndroid ? _bannerAdUnitIdAndroid : _bannerAdUnitIdIOS;

  /// The banner ad instance.
  BannerAd? _bannerAd;

  /// Whether the banner ad is loading.
  bool isLoadingAd = false;

  /// The height of the banner ad.
  double get _height =>
      (widget.height ?? widget.adSize.height.toDouble()) +
      (!widget.isBottom
          ? RagnarokNumExt.topPadding
          : widget.isBottom && Platform.isIOS
              ? RagnarokNumExt.bottomPadding
              : 0.0);

  /// The width of the banner ad.
  double get _width => widget.width ?? double.infinity;

  late StreamSubscription<List<ConnectivityResult>> _connectivitySubscription;

  /// Load the banner ad.
  void load() async {
    try {
      // Prevent loading multiple ads.
      if (isLoadingAd) {
        return;
      }
      isLoadingAd = true;
      setState(() {});
      BannerAd ad = BannerAd(
        adUnitId: bannerAdUnitId,
        size: widget.adSize,
        request: AdRequest(),
        listener: BannerAdListener(
          onAdLoaded: (Ad ad) {
            _bannerAd = ad as BannerAd;
            isLoadingAd = false;
            setState(() {});
          },
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            ad.dispose();
            isLoadingAd = false;
            setState(() {});
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
              'screen': widget.screen ?? context.appNavigator.currentRoute,
            });
          },
          onAdClicked: (ad) {
            /// Log the banner ad click event.
            AnalyticsUtil.logEvent(EventKeyConst.bannerClick, {
              /// The screen name where the banner ad is displayed. if null, use the current screen.
              'screen': widget.screen ?? context.appNavigator.currentRoute,
            });
            AdsService.needToShowAds = false;
          },
        ),
      );
      await ad.load();
    } catch (e, s) {
      appLog.logError(e, stackTrace: s);
      isLoadingAd = false;
      _bannerAd = null;
      setState(() {});
    }
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    _connectivitySubscription.cancel();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    appLog.log('BannerAds: ${_height}', name: 'BannerAds');

    _connectivitySubscription = Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> result) {
      if ((result.contains(ConnectivityResult.wifi) ||
              result.contains(ConnectivityResult.mobile)) &&
          _bannerAd == null) {
        load();
      }
    });
    load();
  }

  @override
  void didUpdateWidget(covariant RagnarokBannerAds oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.screen != widget.screen) {
      load();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (widget.condition != null && !widget.condition!()) {
      return SafeArea(
        top: !widget.isBottom,
        bottom: widget.isBottom,
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
              top: !widget.isBottom,
              bottom: widget.isBottom,
              left: false,
              right: false,
              child: const SizedBox(),
            );
          }
          if (isLoadingAd) {
            return Container(
                width: _width,
                height: _height,
                decoration: BoxDecoration(
                  color: widget.backgroundColor,
                  border: Border.all(color: widget.borderColor),
                ),
                child: SafeArea(
                  bottom: widget.isBottom,
                  top: !widget.isBottom,
                  left: false,
                  right: false,
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                ));
          }
          if (_bannerAd == null) {
            return SafeArea(
              top: !widget.isBottom,
              bottom: widget.isBottom,
              left: false,
              right: false,
              child: const SizedBox(),
            );
          }
          return Container(
            width: _width,
            height: _height,
            decoration: BoxDecoration(
              color: widget.backgroundColor,
              border: Border.all(color: widget.borderColor),
            ),
            child: SafeArea(
              bottom: widget.isBottom,
              top: !widget.isBottom,
              left: false,
              right: false,
              child: AdWidget(ad: _bannerAd!),
            ),
          );
        });
  }
}
