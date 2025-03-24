import 'package:flutter/widgets.dart';

extension ColorExt on Color {
  /// Convert color to hex string
  String get toHex => '#${value.toRadixString(16).substring(2)}';

  /// Convert hex string to color
  static Color fromHex(String hex) {
    final buffer = StringBuffer();
    if (hex.length == 6 || hex.length == 7) buffer.write('ff');
    buffer.write(hex.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Convert value to color
  static Color fromValue(int value) => Color(value);

}
