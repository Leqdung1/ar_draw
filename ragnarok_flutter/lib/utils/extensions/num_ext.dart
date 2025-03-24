import 'dart:ui';

import 'package:flutter/material.dart';

extension RagnarokNumExt on num {
  static FlutterView get _view => PlatformDispatcher.instance.views.first;
  static double get _density => _view.devicePixelRatio;
  static double get topPadding => _view.viewPadding.top / _density;
  static double get bottomPadding => _view.viewPadding.bottom / _density;
  static double get leftPadding => _view.viewPadding.left / _density;
  static double get rightPadding => _view.viewPadding.right / _density;

  double get saveTop => this + topPadding;

  double get saveBottom => this + bottomPadding;

  EdgeInsets get p => EdgeInsets.all(toDouble());

  EdgeInsets get ph => EdgeInsets.symmetric(horizontal: toDouble());

  EdgeInsets get pv => EdgeInsets.symmetric(vertical: toDouble());

  EdgeInsets get pt => EdgeInsets.only(top: toDouble());

  EdgeInsets get pb => EdgeInsets.only(bottom: toDouble());

  EdgeInsets get pl => EdgeInsets.only(left: toDouble());

  EdgeInsets get pr => EdgeInsets.only(right: toDouble());

  BorderRadius get borderRadius => BorderRadius.circular(toDouble());

  BorderRadius get borderTopLeft =>
      BorderRadius.only(topLeft: Radius.circular(toDouble()));

  BorderRadius get borderTopRight =>
      BorderRadius.only(topRight: Radius.circular(toDouble()));

  BorderRadius get borderBottomLeft =>
      BorderRadius.only(bottomLeft: Radius.circular(toDouble()));

  BorderRadius get borderBottomRight =>
      BorderRadius.only(bottomRight: Radius.circular(toDouble()));

  BorderRadius get borderLeft => BorderRadius.only(
      topLeft: Radius.circular(toDouble()),
      bottomLeft: Radius.circular(toDouble()));

  BorderRadius get borderRight => BorderRadius.only(
      topRight: Radius.circular(toDouble()),
      bottomRight: Radius.circular(toDouble()));

  BorderRadius get borderTop => BorderRadius.only(
      topLeft: Radius.circular(toDouble()),
      topRight: Radius.circular(toDouble()));

  BorderRadius get borderBottom => BorderRadius.only(
      bottomLeft: Radius.circular(toDouble()),
      bottomRight: Radius.circular(toDouble()));

  Duration get ms => Duration(milliseconds: toInt());

  Duration get s => Duration(seconds: toInt());

  Duration get m => Duration(minutes: toInt());
}

extension IntExt on int {
  DateTime get toDateTime => DateTime.fromMillisecondsSinceEpoch(this);
}
