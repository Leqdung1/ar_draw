import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class TimeScreen extends StatefulWidget {
  const TimeScreen({super.key, required this.title});

  final String title;

  @override
  State<TimeScreen> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<TimeScreen> {
  Stream<String> streamTimeFromNative() {
    const eventChannel = EventChannel('timeHandlerEvent');
    return eventChannel.receiveBroadcastStream().map(
      (event) => event.toString(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text('Timer :', style: TextStyle(fontSize: 30)),
            StreamBuilder<String>(
              stream: streamTimeFromNative(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text('${snapshot.data}');
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
