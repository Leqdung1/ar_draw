// import 'package:flutter/material.dart';
// import 'package:home_widget/home_widget.dart';

// class HomeWidgetScreen extends StatefulWidget {
//   const HomeWidgetScreen({super.key});

//   @override
//   State<HomeWidgetScreen> createState() => _HomeWidgetScreenState();
// }

// class _HomeWidgetScreenState extends State<HomeWidgetScreen> {
//   int counter = 0;
//   final String androidWidgetName = "com.example.test_ar.HomeWidget";
//   final String dataKey = "text_from_flutter_app";

//   void incrementCounter() async {
//     setState(() {
//       counter++;
//     });

//     String data = "gdsgsfsd fsdasd: $counter";
//     // save widget data
//     await HomeWidget.saveWidgetData(dataKey, data);

//     // update widget after data is saved
//     await HomeWidget.updateWidget(androidName: 'HomeWidget');
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Column(
//         crossAxisAlignment: CrossAxisAlignment.center,
//         mainAxisAlignment: MainAxisAlignment.center,
//         children: [
//           Text("Home Widget Count: $counter"),
//           ElevatedButton(onPressed: incrementCounter, child: Text('Increment')),
//         ],
//       ),
//     );
//   }
// }
