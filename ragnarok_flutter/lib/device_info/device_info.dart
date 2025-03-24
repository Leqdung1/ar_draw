import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';

class DeviceInfo extends DeviceInfoPlugin {
  static const MethodChannel _channel = MethodChannel('ragnarok_flutter');

  @override
  Future<AndroidDeviceInfo> get androidInfo async {
    final Map<String, dynamic> data = (await _channel.invokeMethod('getDeviceInfo')).cast<String, dynamic>();
    final base = BaseDeviceInfo(data);
    return AndroidDeviceInfo.fromMap(base.data);
  }

  Future<String> get deviceId async {
    final devInfo = await deviceInfo;
    if (devInfo is AndroidDeviceInfo) {
      return devInfo.id;
    }
    return (devInfo as IosDeviceInfo).identifierForVendor ?? '';
  }
}
