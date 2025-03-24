import 'dart:io';

import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:ragnarok_flutter/top_level_variable.dart';

import 'att.dart';

class AdsService {
  static MobileAds _mobileAds = MobileAds.instance;

  /// log console
  static bool logConsole = false;

  /// isInitialized
  static bool isInitialized = false;

  /// List of test device ids
  static late List<String> deviceIds;

  /// Function to load ads
  static Function()? _loadAds;

  /// Variable to check if full screen ads is showing
  static bool isShowingAds = false;

  /// Variable to check if app open ads is needed to show
  static bool needToShowAds = true;

  /// EU consent form status
  static bool consentFormIsShowing = false;

  /// Variable to check if user is premium. Premium user will not see ads
  static ValueNotifier<bool> isPremium = ValueNotifier(false);

  /// Initialize ads service
  /// deviceId: list of test device ids
  /// loadAds: function to load ads
  static Future<void> initialize(
      {List<String> deviceId = const [], Function()? loadAds}) async {
    if (Platform.isIOS) {
      return;
    }
    deviceIds = [
      '6A5C2AC24A08A36452B61AAFA366EB7D',
      '38B6F6D8555A8BC1F23DF12BBC7CDC78',
      'DCE6EA0AF1697F86486F590840B24F3A',
      '0A7A255F611C392FF9E567EE9D505BAE',
      'B3EEABB8EE11C2BE770B684D95219ECB',
      '26547AC3355A3544EAB3B7FB5AE2A8E6',
      'CA93E7C7C558121BB9454C2A7E92995E',
      'CBBD9899FFBBAAD9DCAFF90BC72A8AA5',
      '97d063f3a142e06a4ffee26850e8f707',
      '4850c346d489dbaf0ec02cdf302137eb',
      'GADSimulatorID',
      'DB863A1EE4495EAAE4F1DB9AFB0CD3C0',
      '32D2983DC55E7AECB9E8FEE062AE91BF',
      '891157DAE478ABC78512869D9C160D53',
      'EC76B99BF413FEBFE110165ABE163273',
      "07333E9DA716F60A95B00B670BD2D293",
      '107E73830DA20CCB33ECEACDC5DA602D',
      "FAA757687063BBCF4FEA5D085E3F75F6",
      "245A58DCADB53EC78A52690C7B430446",
      "CFEC1B03302A6A5EEA65138294D0184C",
      "3CC30242D374304B789A9015726BAA58",
      ...deviceId,
    ];
    _loadAds = loadAds;
    ATT.requestConsentInfoUpdate(
      deviceIds,
      () async {
        try {
          await _mobileAds.initialize();
          isInitialized = true;

          /// update Test device ids
          _mobileAds.updateRequestConfiguration(
            RequestConfiguration(
              testDeviceIds: deviceIds,
            ),
          );
          _loadAds?.call();
        } catch (e, s) {
          appLog.logError(e, stackTrace: s);
          isInitialized = false;
        }
      },
    );
  }

  /// reinitialize
  static Future<void> reinitialize() async {
    isInitialized = false;
    await initialize(loadAds: _loadAds);
  }

  static void openAdInspector() {
    MobileAds.instance.openAdInspector((p0) {});
  }

  /// overlayState to show loading before full screen ads is showing.
  /// Required to show loading before full screen ads is showing.
  /// Must be set before showing full screen ads.
  /// Suggestions: set overlayState in initState of the first screen
  static OverlayState? overlayState;

  /// overlayEntry to show loading before full screen ads is showing.
  static OverlayEntry? _overlayEntry;

  /// loadingWidget to show loading before full screen ads is showing.
  /// if loadingWidget is null, it will show CircularProgressIndicator
  static Widget? loadingWidget;

  /// Function to remove overlayEntry
  static void removeOverlayEntry() {
    if (_overlayEntry == null) return;
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  /// Function to show overlayEntry
  static void showOverlayEntry() {
    /// if overlayEntry is not null, it means full screen ads is showing
    if (_overlayEntry != null) return;
    _overlayEntry = OverlayEntry(
      builder: (context) =>
          loadingWidget ??
          Positioned.fill(
            child: Container(
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            ),
          ),
    );
    overlayState?.insert(_overlayEntry!);
  }
}
