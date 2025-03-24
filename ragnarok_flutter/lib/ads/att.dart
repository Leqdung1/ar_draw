import 'dart:io';
import 'dart:ui';

import 'package:app_tracking_transparency/app_tracking_transparency.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:ragnarok_flutter/ads/ads_service.dart';

class ATT {
  static ConsentInformation _consentInformation = ConsentInformation.instance;

  static void requestConsentInfoUpdate(
      List<String> testDeviceIds, VoidCallback callback) async {
    final debugSettings = ConsentDebugSettings(
      testIdentifiers: testDeviceIds,
      debugGeography: DebugGeography.debugGeographyEea,
    );

    final consentRequestParams = ConsentRequestParameters(
      tagForUnderAgeOfConsent: false,
      consentDebugSettings: debugSettings,
    );
    if (Platform.isIOS) {
      await AppTrackingTransparency.requestTrackingAuthorization();
    }
    _consentInformation.requestConsentInfoUpdate(
      consentRequestParams,
      () async {
        if (await _consentInformation.isConsentFormAvailable()) {
          await loadForm(callback);
        } else {
          callback();
        }
      },
      (error) {
        print('ConsentInformation: $error');
        callback;
      },
    );
  }

  static Future<void> loadForm(VoidCallback callback) async {
    final status = await _consentInformation.getConsentStatus();
    if (status == ConsentStatus.required) {
      ConsentForm.loadConsentForm(
        (consentForm) async {
          AdsService.consentFormIsShowing = true;
          consentForm.show((res) {
            AdsService.consentFormIsShowing = false;
            print('ConsentForm: $res');
            callback();
          });
        },
        (formError) async {
          callback();
          print('ConsentForm: $formError');
        },
      );
    } else {
      callback();
    }
  }

  static Future<void> showCustomTrackingDialog(
          BuildContext context, Function() init) async =>
      await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Dear User'),
          content: const Text(
            'We care about your privacy and data security. We keep this app free by showing ads. '
            'Can we continue to use your data to tailor ads for you?\n\nYou can change your choice anytime in the app settings. '
            'Our partners will collect data and use a unique identifier on your device to show you ads.',
          ),
          actions: [
            TextButton(
              onPressed: () async {
                Navigator.of(context).pop();
              },
              child: const Text('Continue'),
            ),
          ],
        ),
      ).then((value) async {
        await AppTrackingTransparency.requestTrackingAuthorization();
        init();
      });
}
