import 'package:ragnarok_flutter/navigation/app_routing.dart';
import 'package:test_ar/camera.dart';
import 'package:test_ar/fourth_screen.dart';
import 'package:test_ar/home_screen.dart';
import 'package:test_ar/third_screen.dart';

extension RouteNameExt on RouteName {
  static const String home = '/home';
  static const String camera = '/camera';
  static const String third = '/third';
  static const String fourth = '/fourth';
}

extension AppPageRouteExt on AppPageRoute {
  static AppPageRoute home() =>
      AppWidgetRoute(RouteNameExt.home, builder: homeScreenBuilder);
  static AppPageRoute camera() =>
      AppWidgetRoute(RouteNameExt.camera, builder: cameraScreenBuilder);
  static AppPageRoute third() =>
      AppWidgetRoute(RouteNameExt.third, builder: thirdScreenBuilder);
  static AppPageRoute fourth() =>
      AppWidgetRoute(RouteNameExt.fourth, builder: fourthScreenBuilder);
}
