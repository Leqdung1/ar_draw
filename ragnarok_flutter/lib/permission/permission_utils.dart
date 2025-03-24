import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ragnarok_flutter/ads/ads_service.dart';
import 'package:ragnarok_flutter/navigation/routing.dart';
import 'package:ragnarok_flutter/top_level_variable.dart';

class PermissionUtils {
  static Future<void> permissionHandler({
    required Permission permission,
    required Function() onGranted,
    required Function() onDenied,
  }) async {
    PermissionStatus status = await permission.status;
    if (status.isGranted || status.isLimited || status.isProvisional) {
      onGranted();
      return;
    }
    if (status.isPermanentlyDenied || status.isRestricted) {
      AdsService.needToShowAds = false;
      openAppSettings();
      return;
    }
    AdsService.needToShowAds = false;
    status = await permission.request();
    if (status.isGranted || status.isLimited || status.isProvisional) {
      onGranted();
    } else {
      onDenied();
    }
  }

  // static Future<dynamic> showPermissionDialog(
  //     {required BuildContext context,
  //     required String title,
  //     required String message,
  //     required Function() onGranted,
  //     required Function() onDenied}) {
  //   return showDialog(
  //     context: context,
  //     builder: (context) {
  //       return AlertDialog(
  //         title: Text(title),
  //         content: Text(message),
  //         actions: <Widget>[
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //               onDenied();
  //             },
  //             child: Text(RagnarokStringConst.cancel),
  //           ),
  //           TextButton(
  //             onPressed: () {
  //               Navigator.of(context).pop();
  //               onGranted();
  //             },
  //             child: Text(RagnarokStringConst.ok),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }
}
