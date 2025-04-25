import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';

class Flutter3dScreen extends StatefulWidget {
  const Flutter3dScreen({super.key});

  @override
  State<Flutter3dScreen> createState() => _Flutter3dScreenState();
}

class _Flutter3dScreenState extends State<Flutter3dScreen> {
  double moodValue = 0;

  String get moodText {
    if (moodValue <= 0.2) return "Terrible";
    if (moodValue <= 0.4) return "Bad";
    if (moodValue <= 0.6) return "Okay";
    if (moodValue <= 0.8) return "Good";
    return "Excellent";
  }

  String get moodImage {
    if (moodValue <= 0.2) return "assets/3d/tim_lockwood_icon_head.glb";
    if (moodValue <= 0.4) return "assets/3d/crying_cat.glb";
    if (moodValue <= 0.6) return "assets/3d/funny_fish.glb";
    if (moodValue <= 0.8) return "assets/3d/happy_octopus.glb";
    return "assets/3d/smiling_ice_cream.glb";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            const Text(
              "How do you feel today?",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 220,
              width: 220,
              child: Container(
                decoration: BoxDecoration(
                  color: Color.fromARGB(255, 196, 199, 198),
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(
                        255,
                        203,
                        234,
                        219,
                      ).withOpacity(0.3),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: ClipOval(
                  child: Flutter3DViewer(
                    src: moodImage,
                    progressBarColor: Colors.transparent,
                  ),
                ),
              ),
            ),

            Text(
              moodText,
              style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Slider(
                value: moodValue,
                onChanged: (value) {
                  setState(() {
                    moodValue = value;
                  });
                },
                min: 0,
                max: 1,
                activeColor: Colors.redAccent,
                inactiveColor: Colors.grey[300],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [Text("Terrible"), Text("Excellent")],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    "Continue",
                    style: TextStyle(fontSize: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
