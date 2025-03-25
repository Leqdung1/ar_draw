import 'package:flutter/material.dart';
import 'package:ragnarok_flutter/ads/ragnarok_banner_ads_object.dart';
import 'package:ragnarok_flutter/ads/ragnarok_inters_ads.dart';
import 'package:ragnarok_flutter/ads/ragnarok_native_ads.dart';
import 'package:ragnarok_flutter/ads/ragnarok_open_ads.dart';
import 'package:test_ar/native_ads.dart';

Widget fourthScreenBuilder(BuildContext context, [dynamic data]) {
  return const FourthScreen();
}

class FourthScreen extends StatefulWidget {
  const FourthScreen({super.key});

  @override
  State<FourthScreen> createState() => _FourthScreenState();
}

class _FourthScreenState extends State<FourthScreen> {
  final bannerAdsObject = RagnarokBannerAdsObject(
    isBottom: true,
    screen: 'Fourth',
    onStatusChanged: (status) {
      print('status: $status');
    },
  );
  @override
  void initState() {
    super.initState();
    RagnarokOpenAds.show();
    bannerAdsObject.load();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        RagnarokIntersAds.show();
      },
      child: Scaffold(
        appBar: AppBar(),
        body: Column(
          children: [
            Text('Fourth Screen'),
            Expanded(
              child: NativeAdsWidget(nativeAd: NativeAds.largeNativeAds),
            ),
            const Spacer(),
            bannerAdsObject.build(context),
          ],
        ),
      ),
    );
  }
}
