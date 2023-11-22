import 'package:camera/camera.dart';

class CapturedAchievementArguments {
  final XFile image;
  final Function updateList;

  CapturedAchievementArguments({
    required this.image,
    required this.updateList,
  });
}