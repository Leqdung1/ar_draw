import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class Battery extends StatefulWidget {
  const Battery({super.key});

  @override
  State<Battery> createState() => _BatteryState();
}

class _BatteryState extends State<Battery> {
  String _batteryLevel = 'Waiting for updates...';

  @override
  void initState() {
    super.initState();
    BatteryStream.batteryLevelStream.listen((level) {
      setState(() {
        _batteryLevel = level;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Battery Stream')),
      body: Center(child: Text('Battery Level: $_batteryLevel')),
    );
  }
}


class BatteryStream {
  static const _batteryChannel = EventChannel('batteryHandlerEvent');

  static Stream<String> get batteryLevelStream =>
      _batteryChannel.receiveBroadcastStream().map((event) => event.toString());
}