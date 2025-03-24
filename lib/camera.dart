import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

class CameraScreen extends StatefulWidget {
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class _CameraScreenState extends State<CameraScreen> {
  CameraController? _controller;
  List<CameraDescription>? _cameras;
  bool isOpacity = false;
  bool isLocked = false;
  ValueNotifier<double> opacity = ValueNotifier(0.7);
  Offset imagePosition = Offset.zero;

  @override
  void initState() {
    super.initState();
    _initializeCamera();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      imagePosition = Offset(
        (MediaQuery.of(context).size.width - 200) / 2,
        (MediaQuery.of(context).size.height - 200) / 2,
      );
    });
  }

  Future<void> _initializeCamera() async {
    _cameras = await availableCameras();
    _controller = CameraController(_cameras!.first, ResolutionPreset.medium);
    await _controller!.initialize();
    if (mounted) {
      setState(() {});
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    opacity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || !_controller!.value.isInitialized) {
      return Center(child: CircularProgressIndicator());
    }

    return Scaffold(
      body: Stack(
        children: [
          // Camera Preview
          Positioned.fill(child: CameraPreview(_controller!)),

          Positioned(
            top: imagePosition.dy,
            left: imagePosition.dx,
            child: GestureDetector(
              onPanUpdate: (details) {
                if (!isLocked) {
                  setState(() {
                    imagePosition = imagePosition + details.delta;
                  });
                }
              },
              child: ValueListenableBuilder<double>(
                valueListenable: opacity,
                builder: (context, value, child) {
                  return Center(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        border: Border.all(color: Colors.blue, width: 4),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Opacity(
                        opacity: value,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            'https://www.biowars.com/wp-content/uploads/2023/03/wolf-drawing-final.jpg.webp',
                            width: 200,
                            height: 200,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),

          if (isOpacity)
            Positioned(
              bottom: 150,
              left: 20,
              right: 20,
              child: ValueListenableBuilder<double>(
                valueListenable: opacity,
                builder: (context, value, child) {
                  return Slider(
                    value: value,
                    min: 0,
                    max: 1,
                    onChanged: (value) {
                      opacity.value = value;
                    },
                  );
                },
              ),
            ),

          Positioned(
            bottom: 0,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isOpacity = !isOpacity;
                      });
                    },
                    icon: Icon(
                      Icons.opacity,
                      size: 50,
                      color: isOpacity ? Colors.red : Colors.grey,
                    ),
                  ),
                  SizedBox(width: 50),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        isLocked = !isLocked;
                      });
                      if (isLocked) {
                        imagePosition = Offset(
                          imagePosition.dx,
                          imagePosition.dy,
                        );
                      }
                    },
                    icon: Icon(
                      isLocked ? Icons.lock : Icons.lock_open,
                      size: 50,
                      color: isLocked ? Colors.red : Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
