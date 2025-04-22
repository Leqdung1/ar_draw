// import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
// import 'package:home_widget/home_widget.dart';

// class TimeScreen extends StatefulWidget {
//   const TimeScreen({super.key, required this.title});

//   final String title;

//   @override
//   State<TimeScreen> createState() => _MyHomePageState();
// }

// class _MyHomePageState extends State<TimeScreen> {
//   @override
//   void initState() {
//     super.initState();
//     HomeWidget.registerInteractivityCallback(backgroundCallback);
//   }

//   @pragma('vm:entry-point')
//   static Future<void> backgroundCallback(Uri? uri) async {
//     if (uri?.host == 'click') {
//       // Handle widget click
//       print('Widget clicked!');
//     }
//   }

//   Stream<String> streamTimeFromNative() {
//     const eventChannel = EventChannel('timeHandlerEvent');
//     return eventChannel.receiveBroadcastStream().map(
//       (event) => event.toString(),
//     )..listen((event) {
//       homeWidgetTimer(event.toString());
//     });
//   }

//   final String androidWidgetName = "com.example.test_ar.HomeWidget";
//   final String dataKey = "text_from_flutter_app";

//   void homeWidgetTimer(String data) {
//     HomeWidget.saveWidgetData(dataKey, data);

//     HomeWidget.updateWidget(androidName: 'HomeWidget');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Theme.of(context).colorScheme.inversePrimary,
//         title: Text(widget.title),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: <Widget>[
//             const Text('Timer :', style: TextStyle(fontSize: 30)),
//             StreamBuilder<String>(
//               stream: streamTimeFromNative(),
//               builder: (context, snapshot) {
//                 if (snapshot.hasData) {
//                   return Text('${snapshot.data}');
//                 } else {
//                   return const CircularProgressIndicator();
//                 }
//               },
//             ),
//             const SizedBox(height: 30),
//           ],
//         ),
//       ),
//     );
//   }
// }
