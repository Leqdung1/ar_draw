import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:ragnarok_flutter/ads/ragnarok_open_ads.dart';
import 'package:ragnarok_flutter/navigation/app_routing.dart';
import 'package:ragnarok_flutter/ragnarok_flutter.dart';
import 'package:ragnarok_flutter/top_level_variable.dart';
import 'package:nested/nested.dart';

import '../navigation/app_route_parser.dart';
import '../navigation/app_router.dart';

class RagnarokApp extends MaterialApp {
  RagnarokApp(
      {required this.initAppPageRoute,
      this.routeInformationProvider,
      this.routerConfig,
      this.backButtonDispatcher,
      super.key,
      super.scaffoldMessengerKey,
      super.builder,
      super.title = '',
      super.onGenerateTitle,
      super.onNavigationNotification,
      super.color,
      super.theme,
      super.darkTheme,
      super.highContrastTheme,
      super.highContrastDarkTheme,
      super.themeMode = ThemeMode.system,
      super.themeAnimationDuration = kThemeAnimationDuration,
      super.themeAnimationCurve = Curves.linear,
      super.locale,
      super.localizationsDelegates,
      super.localeListResolutionCallback,
      super.localeResolutionCallback,
      super.supportedLocales = const <Locale>[Locale('en', 'US')],
      super.debugShowMaterialGrid = false,
      super.showPerformanceOverlay = false,
      super.checkerboardRasterCacheImages = false,
      super.checkerboardOffscreenLayers = false,
      super.showSemanticsDebugger = false,
      super.debugShowCheckedModeBanner = true,
      super.shortcuts,
      super.actions,
      super.restorationScopeId,
      super.scrollBehavior,
      super.themeAnimationStyle,
      this.providers = const <SingleChildWidget>[]})
      : assert(RagnarokFlutter.initialized,
            'RagnarokFlutter.initialize() must be called before using RagnarokApp');

  final AppPageRoute initAppPageRoute;
  @override
  final RouteInformationProvider? routeInformationProvider;
  @override
  final RouterConfig<Object>? routerConfig;
  @override
  final BackButtonDispatcher? backButtonDispatcher;

  final List<SingleChildWidget> providers;

  @override
  State<RagnarokApp> createState() => _RagnarokAppState();
}

class _RagnarokAppState extends State<RagnarokApp> {
  late final AppNavigator _router = AppNavigator(widget.initAppPageRoute);

  @override
  void initState() {
    super.initState();
    AppLifecycleReactor().lifeCycleChange();
  }

  @override
  Widget build(BuildContext context) {
    final shortestSide = MediaQuery.of(context).size.shortestSide;
    useMobileLayout = shortestSide < 600;

    return ScreenUtilInit(
      useInheritedMediaQuery: true,
      designSize: useMobileLayout
          ? const Size(390, 844)
          : const Size(1024 / 1.5, 1366 / 1.5),
      builder: (_, child) {
        return MultiProvider(
          providers: [
            ListenableProvider.value(
              value: _router,
            ),
            ...widget.providers,
          ],
          child: MaterialApp.router(
            routerDelegate: _router,
            routeInformationParser: AppRouteInformationParser(),
            theme: widget.theme,
            darkTheme: widget.darkTheme,
            themeMode: widget.themeMode,
            title: widget.title,
            debugShowCheckedModeBanner: widget.debugShowCheckedModeBanner,
            locale: widget.locale,
            localizationsDelegates: widget.localizationsDelegates,
            supportedLocales: widget.supportedLocales,
            builder: EasyLoading.init(
              builder: (context, child) {
                widget.builder?.call(context, child);
                return child!;
              },
            ),
            scaffoldMessengerKey: widget.scaffoldMessengerKey,
            restorationScopeId: widget.restorationScopeId,
            themeAnimationDuration: widget.themeAnimationDuration,
            themeAnimationCurve: widget.themeAnimationCurve,
            themeAnimationStyle: widget.themeAnimationStyle,
            color: widget.color,
            highContrastTheme: widget.highContrastTheme,
            highContrastDarkTheme: widget.highContrastDarkTheme,
            localeListResolutionCallback: widget.localeListResolutionCallback,
            localeResolutionCallback: widget.localeResolutionCallback,
            onGenerateTitle: widget.onGenerateTitle,
            onNavigationNotification: widget.onNavigationNotification,
            shortcuts: widget.shortcuts,
            actions: widget.actions,
            scrollBehavior: widget.scrollBehavior,
          ),
        );
      },
    );
  }
}
