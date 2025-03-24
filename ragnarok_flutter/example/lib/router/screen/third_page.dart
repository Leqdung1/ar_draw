import 'package:flutter/material.dart';

Widget thirdPageScreenBuilder(BuildContext context,[dynamic data]) => const ThirdPage();

class ThirdPage extends StatefulWidget {
  const ThirdPage({super.key});

  @override
  State<ThirdPage> createState() => _ThirdPageState();
}

class _ThirdPageState extends State<ThirdPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Third Page'),
      ),
      body: const Center(
        child: Text('Third Page'),
      ),
    );
  }
}