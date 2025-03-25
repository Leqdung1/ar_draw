import 'dart:ui';

import 'package:ragnarok_flutter/ads/ragnarok_native_ads.dart';


class NativeAds {
  static const String smallNativeAd = 'smallNativeAd';
  static const String largeNativeAd = 'largeNativeAd';

  static RagnarokNativeAds nativeAds = RagnarokNativeAds(
    factoryId: smallNativeAd,
    screen: 'Fourth',
    size: Size(400, 130),
  );

  static RagnarokNativeAds largeNativeAds = RagnarokNativeAds(
    factoryId: largeNativeAd,
    screen: 'Third',
    size: Size(double.infinity, 200),
  );
}
