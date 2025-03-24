import 'package:flutter/material.dart';
import 'routes.dart';

class RouteName {
  static const String init = '/';
}

class AppPageRoute extends NavRoute {
  AppPageRoute(String id, {required NavPageBuilder builder, dynamic data})
      : super(id, builder: builder, data: data);

  static AppPageRoute splash() =>
      AppWidgetRoute(RouteName.init, builder: (context,[data]) => Container());
}

class AppWidgetRoute extends AppPageRoute {
  AppWidgetRoute(
    String id, {
    required WidgetBuilder builder,
    dynamic data,
  }) : super(id,
            builder: (context, [dynamic data]) =>
                _widgetToPage(context, id, builder, data),
            data: data);

  static Page _widgetToPage(
      BuildContext context, String key, WidgetBuilder builder, dynamic data) {
    return MaterialPage(
      child: builder(context),
      key: ValueKey(key),
      name: key,
      arguments: data,
    );
  }
}
