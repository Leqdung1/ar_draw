import 'package:flutter/material.dart';
import 'package:flutter_3d_controller/flutter_3d_controller.dart';
import 'package:test_ar/3d/flutter_3d_screen.dart';

Widget onboardingScreenBuilder(BuildContext context, [dynamic data]) {
  return const OnboardingScreen();
}

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _controller;
  late final ValueNotifier<int> _currentIndex;

  List<String> get images => [
    'assets/3d/suguru_geto.glb',
    'assets/3d/low_poly_adventure_asset_pack.glb',
    'assets/3d/sub.glb',
  ];

  List<String> get titles => [
    'Increase Your Value',
    'Best Digital Solution',
    'Explore New Worlds',
  ];

  List<String> get subTitles => [
    "All tourist destinations are in your hands just click and find the convenience now in phone",
    "from this second you will find an amazing and diverse journey through the grip and click",
    "Explore different places in different countries and find many surprises always by your side",
  ];

  List<Color> get bgColors => [
    Color(0xFFFF5E30),
    Color(0xFF1E40AF),
    Color(0xFF10B981),
  ];

  @override
  void initState() {
    super.initState();
    _controller =
        PageController()..addListener(() {
          _currentIndex.value = _controller.page?.round() ?? 0;
        });
    _currentIndex = ValueNotifier(0);
  }

  @override
  void dispose() {
    _controller.dispose();
    _currentIndex.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: 3,
                itemBuilder: (context, index) {
                  return Container(
                    color: bgColors[index],
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        SizedBox(height: 20),
                        Expanded(
                          flex: 4,
                          child: Flutter3DViewer(src: images[index]),
                        ),
                        Expanded(
                          flex: 3,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                titles[index],
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 30,
                                ),
                                child: Text(
                                  subTitles[index],
                                  style: TextStyle(
                                    color: Colors.white.withOpacity(0.8),
                                    fontSize: 14,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            ValueListenableBuilder(
              valueListenable: _currentIndex,
              builder: (context, value, _) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => Flutter3dScreen(),
                            ),
                          );
                        },
                        child: const Text(
                          'SKIP',
                          style: TextStyle(
                            color: Color.fromARGB(255, 160, 160, 160),
                          ),
                        ),
                      ),
                      Spacer(),
                      ...List.generate(3, (index) {
                        return AnimatedContainer(
                          duration: Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: value == index ? 18 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 160, 160, 160),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }),
                      Spacer(),
                      TextButton(
                        onPressed: () {
                          if (value == 2) {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => Flutter3dScreen(),
                              ),
                            );
                          } else {
                            _controller.animateToPage(
                              value + 1,
                              duration: Duration(milliseconds: 300),
                              curve: Curves.easeInOut,
                            );
                          }
                        },
                        child: Text(
                          value == 2 ? 'GET STARTED' : 'NEXT',
                          style: TextStyle(
                            color: const Color.fromARGB(255, 0, 135, 246),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            const SizedBox(height: 30),
          ],
        ),
      ),
    );
  }
}
