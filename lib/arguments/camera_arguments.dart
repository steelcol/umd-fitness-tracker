import 'package:camera/camera.dart';

class CameraArguments {
  final CameraDescription camera;
  final Function updateList;

  CameraArguments({
    required this.camera,
    required this.updateList,
  });
}
