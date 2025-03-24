import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'routes.dart';

import 'app_routing.dart';

class AppNavigator extends NavigatorRouteDelegate<AppPageRoute> {
  factory AppNavigator.of(BuildContext context) =>
      Provider.of<AppNavigator>(context, listen: false);

  AppNavigator(AppPageRoute initialPath) : super(initialPath);

  // void goToSplash() => pushTo(AppPageRoute.splash());
}

extension AppNavigatorEx on BuildContext {
  AppNavigator get appNavigator => AppNavigator.of(this);

  void setCurrentScreen(bool isPush) => appNavigator.setCurrentScreen = setCurrentScreen;

  bool pop() => appNavigator.pop();

  void pushTo(AppPageRoute path) => appNavigator.pushTo(path);

  void pushAndPopTo(AppPageRoute pushPath, AppPageRoute popToPath) =>
      appNavigator.pushAndPopTo(pushPath, popToPath);

  void replaceLast(AppPageRoute path) => appNavigator.replaceLast(path);

  void popToTop() => appNavigator.popToTop();

  void clearAndPush(AppPageRoute path) => appNavigator.clearAndPush(path);

  StreamSubscription didUpdateLastRoute(Function(String route) onUpdated) =>
      appNavigator.didUpdateLastRoute(onUpdated);

  String get currentRoute => appNavigator.currentRoute;

  String? get previousRoute => appNavigator.previousRoute;
}
