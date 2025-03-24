import 'dart:async';

class EventBusHandler {
  final StreamController<String> _sessionStreamCtrl =
      StreamController<String>.broadcast();

  Stream<String> get stream => _sessionStreamCtrl.stream;
  
  static const String refreshEvent = 'refresh';
  static const String addEvent = 'add';
  static const String deleteEvent = 'delete';

  void fire(String event) {
    _sessionStreamCtrl.add(event);
  }

  void close() {
    _sessionStreamCtrl.close();
  }

  bool checkStreamClosed() {
    return _sessionStreamCtrl.isClosed;
  }
}
