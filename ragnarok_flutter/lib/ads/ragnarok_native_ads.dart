import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:ragnarok_flutter/ads/ads_service.dart';
import 'package:ragnarok_flutter/ads/ads_unit_id_const.dart';
import 'package:ragnarok_flutter/analytics/analytics_util.dart';
import 'package:ragnarok_flutter/remote_config/remote_services.dart';
import 'package:ragnarok_flutter/top_level_variable.dart';

import '../remote_config/remote_key_const.dart';

enum NativeAdStatus { loading, loaded, failed }

class RagnarokNativeAds {
  final String factoryId;
  final String screen;
  final Size size;
  final BoxDecoration? decoration;
  final EdgeInsets? padding;
  /// remote config key for native ad need to load, if null, will load by default
  final String? remoteConfigKey;

  RagnarokNativeAds({
    required this.factoryId,
    required this.screen,
    required this.size,
    this.decoration,
    this.padding,
    this.remoteConfigKey,
  });

  NativeAd? _nativeAd = null;

  ValueNotifier<NativeAdStatus> status = ValueNotifier(NativeAdStatus.failed);

  String get _nativeAdUnitIdAndroid => isDebugMode
      ? AdsUnitIdConst.nativeAdUnitIdAndroidTest
      : RemoteService.getString(RemoteKeyConst.nativeAdUnitIdAndroid);

  String get _nativeAdUnitIdIOS => isDebugMode
      ? AdsUnitIdConst.nativeAdUnitIdIOSTest
      : RemoteService.getString(RemoteKeyConst.nativeAdUnitIdIOS);

  String get nativeAdUnitId =>
      Platform.isAndroid ? _nativeAdUnitIdAndroid : _nativeAdUnitIdIOS;

  bool get isNeedToLoad => remoteConfigKey == null || RemoteService.getBool(remoteConfigKey!);

  Future<void> load() async {
    if (Platform.isIOS) {
      return;
    }
    if (!isNeedToLoad) {
      return;
    }
    try {
      if (status.value == NativeAdStatus.loading) {
        return;
      }
      if (_nativeAd != null && status.value == NativeAdStatus.loaded) {
        return;
      }
      if (!AdsService.isInitialized) {
        return;
      }
      status.value = NativeAdStatus.loading;
      NativeAd ad = NativeAd(
        factoryId: factoryId,
        adUnitId: nativeAdUnitId,
        request: AdRequest(),
        nativeAdOptions: NativeAdOptions(
          videoOptions: VideoOptions(
            startMuted: true,
          ),
        ),
        listener: NativeAdListener(
          onAdLoaded: (Ad ad) {
            _nativeAd = ad as NativeAd;
            status.value = NativeAdStatus.loaded;
            appLog.log('NativeAd loaded: ${_nativeAd?.responseInfo}');
          },
          onAdFailedToLoad: (Ad ad, LoadAdError error) {
            ad.dispose();
            _nativeAd = null;
            status.value = NativeAdStatus.failed;
            if (AdsService.logConsole) {
              print('NativeAd failed to load: $error');
            } else {
              appLog.logError('NativeAd failed to load: $error');
            }
          },
          onAdImpression: (ad) {
            AnalyticsUtil.logEvent(EventKeyConst.nativeAdImpression, {
              'screen': screen,
            });
          },
          onAdClicked: (ad) {
            AnalyticsUtil.logEvent(EventKeyConst.nativeAdClick, {
              'screen': screen,
            });
            AdsService.needToShowAds = false;
            _nativeAd?.dispose();
            _nativeAd = null;
            status.value = NativeAdStatus.failed;
            load();
          },
        ),
      );
      ad.load();
    } catch (e, s) {
      appLog.logError('NativeAd failed to load: $e');
      status.value = NativeAdStatus.failed;
    }
  }
}

class NativeAdsWidget extends StatefulWidget {
  const NativeAdsWidget({
    required this.nativeAd,
    this.condition,
    super.key,
  });

  final RagnarokNativeAds nativeAd;
  final bool Function()? condition;

  @override
  State<NativeAdsWidget> createState() => _NativeAdsWidgetState();
}

class _NativeAdsWidgetState extends State<NativeAdsWidget> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(minutes: 5), (timer) {
      if (widget.nativeAd.status.value == NativeAdStatus.loaded ||
          AdsService.isPremium.value) {
        timer.cancel();
      }
      if (widget.nativeAd.status.value == NativeAdStatus.failed) {
        widget.nativeAd.load();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (widget.condition != null && !widget.condition!())
      return const SizedBox();
    return ValueListenableBuilder(
        valueListenable: AdsService.isPremium,
        builder: (context, isPremium, child) {
          if (isPremium) {
            return const SizedBox();
          }
          return ValueListenableBuilder(
              valueListenable: widget.nativeAd.status,
              builder: (context, status, child) {
                if (status == NativeAdStatus.loading) {
                  return adWidget(
                    child: const Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }
                if (status == NativeAdStatus.failed ||
                    widget.nativeAd._nativeAd == null) {
                  return const SizedBox();
                }
                return adWidget(
                  child: AdWidget(ad: widget.nativeAd._nativeAd!),
                );
              });
        });
  }

  Widget adWidget({required Widget child}) {
    return Container(
      height: widget.nativeAd.size.height,
      width: widget.nativeAd.size.width,
      decoration: widget.nativeAd.decoration,
      margin: widget.nativeAd.padding,
      child: child,
    );
  }
}
