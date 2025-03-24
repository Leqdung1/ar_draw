import 'package:flutter/widgets.dart';

extension RagnarokStringExt on String? {
  bool get isBlank =>
      this == null ||
      this!.trim().isEmpty ||
      this!.trim().toLowerCase() == 'null';

  bool get isNotBlank => !isBlank;

  String get orEmpty => this ?? '';

  String valueOr(String defaultValue) => isBlank ? defaultValue : orEmpty;

  /// Cut string with length
  /// If string is null or empty, return empty string
  /// [left] and [right] is the length of the string you want to keep
  /// [separator] is the string that separate the left and right string, default is '...'
  /// example: '123456789'.cut(left: 3, right: 3) => '123...789'
  /// example: '123456789'.cut(left: 3) => '123...'
  /// example: '123456789'.cut(right: 3) => '...789'
  String cut({int left = 0, int right = 0, String separator = '...'}) {
    if (isBlank) {
      return '';
    }

    if (this!.length <= left + right) {
      return this!;
    }

    if (left == 0) {
      if (right > this!.length) {
        return this!.substring(this!.length - right);
      }
    }

    if (right == 0) {
      if (left > this!.length) {
        return this!.substring(0, left);
      }
    }

    return '${this!.substring(0, left)}$separator${this!.substring(this!.length - right)}';
  }

  String get capitalize =>
      this!.isBlank ? '' : '${this![0].toUpperCase()}${this!.substring(1)}';

  String get capitalizeEachWord =>
      this!.split(' ').map((word) => word.capitalize).join(' ');

  Widget toText({
    TextStyle? style,
    StrutStyle? strutStyle,
    TextAlign? textAlign,
    TextDirection? textDirection,
    Locale? locale,
    bool? softWrap,
    TextOverflow? overflow,
    TextScaler? textScaler,
    int? maxLines,
    String? semanticsLabel,
    TextWidthBasis? textWidthBasis,
    TextHeightBehavior? textHeightBehavior,
    Color? selectionColor,
  }) {
    if (isBlank) {
      return const SizedBox.shrink();
    }

    return Text(
      this!,
      style: style,
      strutStyle: strutStyle,
      textAlign: textAlign,
      textDirection: textDirection,
      locale: locale,
      softWrap: softWrap,
      overflow: overflow,
      textScaler: textScaler,
      maxLines: maxLines,
      semanticsLabel: semanticsLabel,
      textWidthBasis: textWidthBasis,
      textHeightBehavior: textHeightBehavior,
      selectionColor: selectionColor,
    );
  }
}
