import 'package:flutter/services.dart';

class ThrowCrash {
  static const MethodChannel _channel = MethodChannel('ragnarok_flutter');
  static const String _method = 'crash';

  static void crash(String message) {
    _channel.invokeMethod(_method, {'message': message});
  }
}