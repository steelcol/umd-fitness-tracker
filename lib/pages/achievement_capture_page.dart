import 'package:BetaFitness/utilities/routes.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:BetaFitness/arguments/captured_achievement_arguments.dart';

class AchievementCapturePage extends StatefulWidget {
  AchievementCapturePage({Key? key,
    required this.camera,
    required this.updateList,
  }) : super(key: key);

  final CameraDescription camera;
  final Function updateList;

  @override
  State<AchievementCapturePage> createState() => _AchievementCapturePageState();
}

class _AchievementCapturePageState extends State<AchievementCapturePage> {
  late CameraController _cameraController;
  late Future<void> _initializeControllerFeature;

  bool _cameraOn = true;

  void _createCameraController() {
    _cameraController = new CameraController(
        widget.camera,
        ResolutionPreset.low
    );
    _initializeControllerFeature = _cameraController.initialize();
  }

  @override
  void initState() {
    super.initState();

    // create cameraController
    _createCameraController();
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
            return Column(
                children: [
                  _cameraOn ? CameraPreview(_cameraController) : Container(),
                  Expanded(
                    flex: 3,
                    child: ElevatedButton(
                      style: ButtonStyle(
                        shape: MaterialStateProperty.all(CircleBorder()),
                        minimumSize: MaterialStateProperty.all(
                            Size.square(MediaQuery.sizeOf(context).width/5)
                        ),
                        backgroundColor: MaterialStateProperty.all(Colors.white70),
                      ),
                      onPressed: () async {
                        try {
                          await _initializeControllerFeature;

                          _cameraController.setFlashMode(FlashMode.off);
                          final image = await _cameraController.takePicture();

                          if (!mounted) return;

                          setState(() {
                            _cameraOn = false;
                            _cameraController.pausePreview();
                          });
                          await Navigator.pushNamed(
                            context,
                            displayCapturedAchievementPageRoute,
                            arguments: CapturedAchievementArguments(
                              image: image,
                              updateList: widget.updateList,
                            )
                          ).then((_) {
                            setState(() {
                              _cameraController.resumePreview();
                              _cameraOn = true;
                            });
                          });
                        } catch (e) {
                          print("ERROR $e");
                        }
                      },
                      child: const Icon(Icons.camera_alt),
                    ),
                  ),
                ]
            );
          } else {
            return const Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }
}