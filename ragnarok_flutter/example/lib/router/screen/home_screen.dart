import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:ragnarok_flutter/navigation/app_router.dart';
import 'package:ragnarok_flutter_example/router/router_extension.dart';

Widget homeScreenBuilder(BuildContext context,[dynamic data]) => const HomeScreen();

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Screen'),
      ),
      body: Column(
        children: [
          const Center(
            child: Text('Home Screen'),
          ),
          ElevatedButton(
            onPressed: () {
              context.pushTo(AppPageRouteExt.firstPage());
            },
            child: const Text('Go to First Page'),
          ),
          ElevatedButton(
            onPressed: () {
              context.pushTo(AppPageRouteExt.secondPage());
            },
            child: const Text('Go to Second Page'),
          ),
          ElevatedButton(
            onPressed: () {
              context.pushTo(AppPageRouteExt.thirdPage());
            },
            child: const Text('Go to Third Page'),
          ),
        ],
      )
    );
  }
}