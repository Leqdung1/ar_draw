import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';

class Flutter3dScreen extends StatelessWidget {
  const Flutter3dScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter 3D')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 500,
                child: Flutter3DViewer(
                  src: 'assets/3d/swiss_cheese_foliage.glb',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
