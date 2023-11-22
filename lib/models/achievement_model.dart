import 'dart:typed_data';

class Achievement {
  DateTime dateCaptured;
  String description;
  Uint8List image;

  Achievement({
    required this.dateCaptured,
    required this.description,
    required this.image,
  });
}