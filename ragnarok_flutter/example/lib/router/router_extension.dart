import 'package:ragnarok_flutter/navigation/app_routing.dart';
import 'package:ragnarok_flutter_example/router/screen/first_page.dart';
import 'package:ragnarok_flutter_example/router/screen/home_screen.dart';
import 'package:ragnarok_flutter_example/router/screen/second_page.dart';
import 'package:ragnarok_flutter_example/router/screen/third_page.dart';

extension AppRouteNameExt on RouteName {
  static const home = '/home';
  static const firstPage = '/firstPage';
  static const secondPage = '/secondPage';
  static const thirdPage = '/thirdPage';
}

extension AppPageRouteExt on AppPageRoute {
  static AppPageRoute get home => AppWidgetRoute(
        AppRouteNameExt.home,
        builder: homeScreenBuilder,
      );

  static AppPageRoute firstPage() => AppWidgetRoute(
        AppRouteNameExt.firstPage,
        builder: firstPageScreenBuilder,
      );

  static AppPageRoute secondPage() => AppWidgetRoute(
        AppRouteNameExt.secondPage,
        builder: secondPageScreenBuilder,
      );

  static AppPageRoute thirdPage() => AppWidgetRoute(
        AppRouteNameExt.thirdPage,
        builder: thirdPageScreenBuilder,
      );
}