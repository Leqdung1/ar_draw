package com.example.test_ar

import LargeNativeAdFactory
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugins.googlemobileads.GoogleMobileAdsPlugin

class MainActivity : FlutterActivity(){
    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val smallNativeFactory = SmallNativeFactory(layoutInflater)
        GoogleMobileAdsPlugin.registerNativeAdFactory(flutterEngine,"smallNativeAd" ,smallNativeFactory)
        val largeNativeAdFactory = LargeNativeAdFactory(layoutInflater)
        GoogleMobileAdsPlugin.registerNativeAdFactory(flutterEngine, "largeNativeAd", largeNativeAdFactory)
    }

    override fun detachFromFlutterEngine() {
        super.detachFromFlutterEngine()
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "smallNativeAd")
        GoogleMobileAdsPlugin.unregisterNativeAdFactory(flutterEngine, "largeNativeAd")
    }
}
