import 'dart:developer' as dev;
import "dart:io" as io;

import 'package:flutter/foundation.dart';
import 'package:ragnarok_flutter/utils/extensions/string_ext.dart';

class AppLog {
  void log(
    Object? message, {
    String name = 'Ragnarok Log',
    int length = 1000,
  }) {
    if (kReleaseMode) return;
      dev.log('$message'.cut(left: length), name: name);
  }

  void logError(
    Object? message, {
    StackTrace? stackTrace,
    String name = 'Ragnarok Log Error',
    int length = 1000,
  }) {
    if (kReleaseMode) return;
    dev.log('$message\n$stackTrace'.cut(left: length), name: name);
  }
}
