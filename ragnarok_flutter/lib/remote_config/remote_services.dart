import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:ragnarok_flutter/remote_config/remote_key_const.dart';

class RemoteService {
  static final FirebaseRemoteConfig _remoteConfig = FirebaseRemoteConfig.instance;

  static Future<void> initialize({
    Duration fetchTimeout = const Duration(seconds: 10),
    Duration minimumFetchInterval = const Duration(hours: 1),
    Map<String,dynamic> defaults = const <String,dynamic>{},
    String bannerAdUnitIdAndroid = '',
    String bannerAdUnitIdIOS = '',
    String interstitialAdUnitIdAndroid = '',
    String interstitialAdUnitIdIOS = '',
    String rewardedAdUnitIdAndroid = '',
    String rewardedAdUnitIdIOS = '',
    String nativeAdUnitIdAndroid = '',
    String nativeAdUnitIdIOS = '',
    String appOpenAdUnitIdAndroid = '',
    String appOpenAdUnitIdIOS = '',
    int sessionNumberToShowIntersAd = 0,
    int interstitialShowAdInterval = 15,
    int sessionNumberToShowRewardedAd = 0,
    int rewardedShowAdInterval = 15,
    int sessionNumberToShowAppOpenAd = 0,
    int appOpenShowAdInterval = 15,
}) async {
    _setSettings(fetchTimeout: fetchTimeout, minimumFetchInterval: minimumFetchInterval);
    _remoteConfig.setDefaults({
      RemoteKeyConst.bannerAdUnitIdAndroid: bannerAdUnitIdAndroid,
      RemoteKeyConst.bannerAdUnitIdIOS: bannerAdUnitIdIOS,
      RemoteKeyConst.interstitialAdUnitIdAndroid: interstitialAdUnitIdAndroid,
      RemoteKeyConst.interstitialAdUnitIdIOS: interstitialAdUnitIdIOS,
      RemoteKeyConst.rewardedAdUnitIdAndroid: rewardedAdUnitIdAndroid,
      RemoteKeyConst.rewardedAdUnitIdIOS: rewardedAdUnitIdIOS,
      RemoteKeyConst.nativeAdUnitIdAndroid: nativeAdUnitIdAndroid,
      RemoteKeyConst.nativeAdUnitIdIOS: nativeAdUnitIdIOS,
      RemoteKeyConst.appOpenAdUnitIdAndroid: appOpenAdUnitIdAndroid,
      RemoteKeyConst.appOpenAdUnitIdIOS: appOpenAdUnitIdIOS,
      RemoteKeyConst.sessionNumberToShowIntersAd: sessionNumberToShowIntersAd,
      RemoteKeyConst.interstitialShowAdInterval: interstitialShowAdInterval,
      RemoteKeyConst.sessionNumberToShowRewardedAd: sessionNumberToShowRewardedAd,
      RemoteKeyConst.rewardedShowAdInterval: rewardedShowAdInterval,
      RemoteKeyConst.sessionNumberToShowAppOpenAd: sessionNumberToShowAppOpenAd,
      RemoteKeyConst.appOpenShowAdInterval: appOpenShowAdInterval,
      ...defaults,
    });
    try{
      _remoteConfig.fetchAndActivate();
    }catch(e){
      print(e);
    }
  }

  static void _setSettings({
    Duration fetchTimeout = const Duration(seconds: 10),
    Duration minimumFetchInterval = const Duration(hours: 1),}) {
    _remoteConfig.setConfigSettings(RemoteConfigSettings(
      fetchTimeout: fetchTimeout,
      minimumFetchInterval: minimumFetchInterval,
    ));
  }

  static String getString(String key) {
    return _remoteConfig.getString(key);
  }

  static int getInt(String key) {
    return _remoteConfig.getInt(key);
  }

  static double getDouble(String key) {
    return _remoteConfig.getDouble(key);
  }

  static bool getBool(String key) {
    return _remoteConfig.getBool(key);
  }
}