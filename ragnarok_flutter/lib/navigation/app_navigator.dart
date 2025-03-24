part of routing.base;

///
abstract class NavigatorRouteDelegate<PathRoute extends NavRoute>
    extends RouterDelegate<PathRoute>
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  NavigatorRouteDelegate(PathRoute initialPath) {
    this._routes.add(initialPath);
  }

  final StreamController<String> _controller =
      StreamController<String>.broadcast();

  @override
  final GlobalKey<NavigatorState>? navigatorKey = GlobalKey();

  final List<PathRoute> _routes = [];

  final List<Completer<dynamic>> _resultCompleter = [];

  void Function(bool isPush)? setCurrentScreen;

  // static FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  @override
  Widget build(BuildContext context) {
    appLog.log(_routes.map((r) => r.id).join(' => '));
    return WillPopScope(
      onWillPop: () => Future.value(pop()),
      child: Navigator(
        key: navigatorKey,
        onPopPage: _onPopPage,
        pages: _getPages(context),
      ),
    );
  }

  List<Page> _getPages(BuildContext context) {
    return _routes.map((route) => route.builder(context)).toList();
  }

  List<Page> getPages(BuildContext context) {
    return _routes.map((e) => e.builder(context)).toList();
  }

  @override
  Future<void> setNewRoutePath(PathRoute configuration) async {}

  StreamSubscription didUpdateLastRoute(Function(String route) onUpdated) {
    return _controller.stream.listen((event) {
      onUpdated(event);
    });
  }

  bool _onPopPage(Route<dynamic> route, dynamic result) {
    if (!route.didPop(result)) {
      return false;
    }
    return pop();
  }

  ///
  bool pop() {
    if (canPop()) {
      _routes.removeLast();
      _controller.add(_routes.last.id);
      _setCurrentScreen(isPush: false);
      notifyListeners();
      // InterstitialAds.numSessionToShow++;
      // InterstitialAds.showInterstitialAd();
      return true;
    }
    return false;
  }

  void popUntil(String path) {
    final index = _routes.indexWhere((element) => element.id == path);
    if (index >= 0) {
      _routes.removeRange(index + 1, _routes.length);
      _controller.add(_routes.last.id);
      _setCurrentScreen(isPush: false);
      notifyListeners();
    }
  }

  bool canPop() {
    return _routes.length > 1;
  }

  void pushTo(PathRoute path) {
    if (_routes.last.id == path.id) {
      return;
    }
    _routes.add(path);
    _controller.add(_routes.last.id);
    _setCurrentScreen();
    notifyListeners();
  }

  Future<dynamic> pushAndWaitForResult(PathRoute path) async {
    _resultCompleter.add(Completer<dynamic>());
    _routes.add(path);
    _setCurrentScreen();
    notifyListeners();
    return _resultCompleter.last.future;
  }

  /// This is custom method to pass returning value
  /// while popping the page. It can be considered as an example
  /// alternative to returning value with `Navigator.pop(context, value)`.
  void popWithResult(dynamic value) {
    _routes.removeLast();
    _controller.add(_routes.last.id);
    _resultCompleter.last.complete(value);
    _resultCompleter.removeLast();
    _setCurrentScreen(isPush: false);
    // InterstitialAds.numSessionToShow++;
    // InterstitialAds.showInterstitialAd();
    notifyListeners();
  }

  void pushAndPopTo(PathRoute pushPath, PathRoute popToPath) {
    final index = _routes.indexWhere((element) => element.id == popToPath.id);
    if (index >= 0) {
      _routes.removeRange(index + 1, _routes.length);
    }
    _routes.add(pushPath);
    _controller.add(_routes.last.id);
    _setCurrentScreen();
    notifyListeners();
  }

  void replaceLast(PathRoute path) {
    if (_routes.isNotEmpty) {
      _routes.removeLast();
    }
    _routes.add(path);
    _controller.add(_routes.last.id);
    _setCurrentScreen();
    notifyListeners();
  }

  void clearAndPush(PathRoute path) {
    final _lastRoute = _routes.lastOrNull;
    _routes.clear();
    _routes.add(path);
    _controller.add(_routes.last.id);
    _setCurrentScreen(previousRoute: _lastRoute?.id);
    notifyListeners();
  }

  void clearAndPushRoutes(List<PathRoute> paths) {
    final _lastRoute = _routes.lastOrNull;
    _routes.clear();
    _routes.addAll(paths);
    _controller.add(_routes.last.id);
    _setCurrentScreen(previousRoute: _lastRoute?.id);
    notifyListeners();
  }

  void pushRoutes(List<PathRoute> paths) {
    _routes.addAll(paths);
    _controller.add(_routes.last.id);
    _setCurrentScreen();
    notifyListeners();
  }

  void clearAndPushMulti(List<PathRoute> paths) {
    _routes.clear();
    _routes.addAll(paths);
    _controller.add(_routes.last.id);
    _setCurrentScreen();
    notifyListeners();
  }

  void popToTop() {
    _routes.removeRange(1, _routes.length);
    _controller.add(_routes.last.id);
    _setCurrentScreen(isPush: false);
    notifyListeners();
  }

  void popToTopAndPush(PathRoute route) {
    _routes
      ..removeRange(1, _routes.length)
      ..add(route);
    _controller.add(_routes.last.id);
    _setCurrentScreen();
    notifyListeners();
  }

  bool pushAndRemoveIfExisting(PathRoute route) {
    final _lastRoute = _routes.lastOrNull;
    if (_routes.last.id == route.id) {
      return false;
    }
    final routeIndex =
        _routes.map((r) => r.id).toList().indexWhere((id) => id == route.id);
    if (routeIndex != -1) {
      _routes.removeAt(routeIndex);
    }
    _routes.add(route);
    _setCurrentScreen(previousRoute: _lastRoute?.id);
    notifyListeners();
    return true;
  }

  String get currentRoute => _routes.last.id;

  String? get previousRoute =>
      _routes.length == 1 ? null : _routes[_routes.length - 2].id;

  void _setCurrentScreen({bool isPush = true, String? previousRoute}) {
    if (setCurrentScreen != null) {
      setCurrentScreen?.call(isPush);
      return;
    }
    AnalyticsUtil.logScreen(screenName: _routes.last.id);
    if (isPush) {
      AnalyticsUtil.logScreenEntry(_routes.last.id,
          previousScreenName: previousRoute ?? this.previousRoute);
    }
  }
}
