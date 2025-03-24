

import 'package:ragnarok_flutter/navigation/app_routing.dart';
import 'package:test_ar/camera.dart';
import 'package:test_ar/home_screen.dart';

extension RouteNameExt on RouteName {
  static const String home = '/home';
  static const String camera = '/camera';
 
}

extension AppPageRouteExt on AppPageRoute {
  static AppPageRoute home() => AppWidgetRoute(
        RouteNameExt.home,
        builder: homeScreenBuilder,
      );
  static AppPageRoute camera() => AppWidgetRoute(
        RouteNameExt.camera,
        builder: cameraScreenBuilder,
      );

}
