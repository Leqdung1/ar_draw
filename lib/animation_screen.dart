import 'dart:math';

import 'package:flutter/material.dart';

class AnimationScreen extends StatefulWidget {
  const AnimationScreen({super.key});

  @override
  State<AnimationScreen> createState() => _AnimationScreenState();
}

class _AnimationScreenState extends State<AnimationScreen>
    with TickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<Offset> animation;
  late Animation<Offset> animationArrow;
  late Animation<double> animationHeart;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    animation = Tween(
      begin: const Offset(0, -1),
      end: const Offset(0, 10),
    ).animate(
      CurvedAnimation(parent: animationController, curve: Curves.easeInOut),
    );

    animationArrow = Tween(
      begin: Offset(0, 0),
      end: Offset(pi, 0),
    ).animate(animationController);

    animationHeart = Tween<double>(begin: 70.0, end: 180.0).animate(
      CurvedAnimation(parent: animationController, curve: Curves.linear),
    );
  }

  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Column(
          children: [
            SlideTransition(position: animation, child: Icon(Icons.arrow_back)),

            AnimatedBuilder(
              animation: animationArrow,
              builder: (context, child) {
                return Transform.rotate(
                  angle: animationArrow.value.dx,
                  child: Icon(Icons.arrow_forward, color: Colors.red),
                );
              },
            ),
            AnimatedBuilder(
              animation: animationHeart,
              builder: (context, child) {
                return Icon(
                  Icons.favorite,
                  color: Colors.red,
                  size: animationHeart.value,
                );
              },
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: () {
                animationController.reset();
                animationController.forward();
              },
              child: Text('Press here'),
            ),
            
          ],
        ),
      ),
    );
  }
}
