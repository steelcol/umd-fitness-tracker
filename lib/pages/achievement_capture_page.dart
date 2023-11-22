import 'package:BetaFitness/utilities/routes.dart';
//import 'package:firebase_core/firebase_core.dart';
//import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:BetaFitness/controllers/achievement_controller.dart';
import 'package:BetaFitness/arguments/captured_achievement_arguments.dart';
//import 'dart:typed_data';

class AchievementCapturePage extends StatefulWidget {
  AchievementCapturePage({Key? key, required this.camera}) : super(key: key);

  final CameraDescription camera;

  @override
  State<AchievementCapturePage> createState() => _AchievementCapturePageState();
}

class _AchievementCapturePageState extends State<AchievementCapturePage> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFeature;

  final AchievementController _achievementController = AchievementController();

  @override
  void initState() {
    super.initState();

    // create cameraController
    _cameraController = CameraController(
        widget.camera,
        ResolutionPreset.medium
    );

    _initializeControllerFeature = _cameraController.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed of
    _cameraController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold (
      appBar: AppBar(
        title: const Text('BetaFitness')
      ),
      body: FutureBuilder<void>(
        future: _initializeControllerFeature,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            return CameraPreview(_cameraController);
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          try {
            await _initializeControllerFeature;

            final image = await _cameraController.takePicture();

            if (!mounted) return;

            await Navigator.pushNamed(
                context,
                displayCapturedAchievementPageRoute,
                arguments: CapturedAchievementArguments(image: image)
            );
          } catch (e) {
            print("ERROR $e");
          }
        },
        child: const Icon(Icons.camera_alt),
      ),
    );
  }
}

// class DisplayCapturedAchievement extends StatelessWidget{
//   final XFile image;
//
//   const DisplayCapturedAchievement({Key? key, required this.image}) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('BetaFitness')),
//       body: Image.file(image as File),
//     );
//   }
// }