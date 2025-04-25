import 'package:ragnarok_flutter/navigation/app_routing.dart';
import 'package:test_ar/3d/onboarding_screen.dart';


extension RouteNameExt on RouteName {
  static const String onboarding = '/onboarding';
 
}

extension AppPageRouteExt on AppPageRoute {
static AppPageRoute onboarding() =>
      AppWidgetRoute(RouteNameExt.onboarding, builder: onboardingScreenBuilder);
}
