import 'dart:io';

import 'package:flutter/material.dart';
import 'package:ragnarok_flutter/ads/ragnarok_banner_ads_object.dart';
import 'package:ragnarok_flutter/ads/ragnarok_inters_ads.dart';
import 'package:ragnarok_flutter/ads/ragnarok_native_ads.dart';
import 'package:ragnarok_flutter/ads/ragnarok_open_ads.dart';
import 'package:test_ar/native_ads.dart';

Widget thirdScreenBuilder(BuildContext context, [dynamic data]) {
  return const ThirdScreen();
}

class ThirdScreen extends StatefulWidget {
  const ThirdScreen({super.key});

  @override
  State<ThirdScreen> createState() => _ThirdScreenState();
}

class _ThirdScreenState extends State<ThirdScreen> {
  final bannerAdsObject = RagnarokBannerAdsObject(
    isBottom: false,
    screen: 'Third',
    onStatusChanged: (status) {
      print(status);
    },
  );

  @override
  void initState() {
    super.initState();
    RagnarokOpenAds.show();
    bannerAdsObject.load();
    NativeAds.smallNativeAds.load();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        RagnarokIntersAds.show();
      },
      child: Scaffold(
        body: Column(
          children: [
            bannerAdsObject.build(context),
            AppBar(title: const Text('Third Screen')),
            Text('hello'),
            Container(height: 100, color: Colors.red),
            NativeAdsWidget(nativeAd: NativeAds.smallNativeAds),
          ],
        ),
      ),
    );
  }
}
