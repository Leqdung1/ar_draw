import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ragnarok_flutter/ads/ragnarok_native_ads.dart';

class NativeAds {
  static const String smallNativeAd = 'smallNativeAd';
  static const String largeNativeAd = 'largeNativeAd';

  static RagnarokNativeAds smallNativeAds = RagnarokNativeAds(
    factoryId: smallNativeAd,
    screen: 'Fourth',
    size: Size(400, 150),
    decoration: BoxDecoration(color: const Color.fromARGB(255, 232, 244, 255)),
  );

  static RagnarokNativeAds smallNativeAds1 = RagnarokNativeAds(
    factoryId: smallNativeAd,
    screen: 'five',
    size: Size(400, 150),
    decoration: BoxDecoration(color: const Color.fromARGB(255, 232, 244, 255)),
  );

  static RagnarokNativeAds largeNativeAds = RagnarokNativeAds(
    factoryId: largeNativeAd,
    screen: 'Third',
    size: Size(double.infinity, 700),
    padding: EdgeInsets.symmetric(horizontal: 20),
    decoration: BoxDecoration(color: const Color.fromARGB(255, 232, 244, 255)),
  );
}
