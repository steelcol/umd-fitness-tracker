import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'dart:io';

class DisplayCapturedAchievementPage extends StatelessWidget{

  final XFile image;

  const DisplayCapturedAchievementPage({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BetaFitness')),
      body: Image.file(image as File),
    );
  }
}