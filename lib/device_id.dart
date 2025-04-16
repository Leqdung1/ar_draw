import 'package:device_info_plus/device_info_plus.dart';
import 'dart:io';

Future<String?> getDeviceId() async {
  final deviceInfo = DeviceInfoPlugin();

  if (Platform.isAndroid) {
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    return androidInfo.id; // This is the Android ID
  }

  // For iOS or other platforms, handle separately
  return null;
}
