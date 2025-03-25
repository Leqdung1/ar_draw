import 'package:flutter/material.dart';
import 'package:ragnarok_flutter/ads/ragnarok_banner_ads_object.dart';
import 'package:ragnarok_flutter/ads/ragnarok_open_ads.dart';
import 'package:test_ar/camera.dart';
import 'package:test_ar/fourth_screen.dart';
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
      print(status);
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
