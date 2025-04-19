import 'package:flutter/material.dart';
import 'package:ragnarok_flutter/ads/ragnarok_banner_ads_object.dart';
import 'package:test_ar/animation_screen.dart';
import 'package:test_ar/camera.dart';
import 'package:test_ar/device_id.dart';
import 'package:test_ar/firebase_screen.dart';
import 'package:test_ar/fourth_screen.dart';
import 'package:test_ar/home_widget.dart';
import 'package:test_ar/home_widget_counter.dart';
import 'package:test_ar/notifi_screen.dart';
import 'package:test_ar/noti_scheduling.dart';
import 'package:test_ar/third_screen.dart';

Widget homeScreenBuilder(BuildContext context, [dynamic data]) {
  return const HomeScreen();
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final bannerAdsObject = RagnarokBannerAdsObject(
    isBottom: false,
    screen: 'Home',
    onStatusChanged: (status) {
      print('status: $status');
    },
  );

  @override
  void initState() {
    super.initState();
    bannerAdsObject.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          bannerAdsObject.build(context),
          AppBar(title: const Text('Home')),
          const Center(child: Text('Home')),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ThirdScreen()),
              );
            },
            child: const Icon(Icons.camera),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FourthScreen()),
              );
            },
            child: const Icon(Icons.arrow_forward_ios),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => NotifiScreen()),
              );
            },
            child: const Icon(Icons.notification_add, color: Colors.red),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => TestNoti()),
              );
            },
            child: const Icon(Icons.notifications, color: Colors.green),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => FirebaseScreen()),
              );
            },
            child: const Icon(Icons.fire_truck, color: Colors.orange),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AnimationScreen()),
              );
            },
            child: const Icon(
              Icons.animation,
              color: Color.fromARGB(255, 74, 131, 81),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AnimationScreen()),
              );
            },
            child: const Icon(
              Icons.image,
              color: Color.fromARGB(255, 74, 131, 81),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              getDeviceId().then((value) {
                print('deviceId: $value');
              });
            },
            child: const Icon(
              Icons.person,
              color: Color.fromARGB(255, 74, 131, 81),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeWidgetScreen()),
              );
            },
            child: const Icon(
              Icons.mobile_screen_share_sharp,
              color: Color.fromARGB(255, 74, 131, 81),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HomeWidgetCounter(title: 'Home'),
                ),
              );
            },
            child: const Icon(
              Icons.mobile_friendly,
              color: Color.fromARGB(255, 74, 131, 81),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => CameraScreen()),
          );
        },
        child: const Icon(Icons.camera),
      ),
    );
  }
}
