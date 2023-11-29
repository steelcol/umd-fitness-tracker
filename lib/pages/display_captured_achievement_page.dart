import 'dart:convert';
import 'dart:io';

import 'package:BetaFitness/controllers/achievement_controller.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:BetaFitness/models/achievement_model.dart';

class DisplayCapturedAchievementPage extends StatefulWidget {
  DisplayCapturedAchievementPage({
    Key? key,
    required this.image,
    required this.updateList,
  }) : super(key: key);

  final XFile image;
  final Function updateList;

  @override
  State<DisplayCapturedAchievementPage> createState() =>
      _DisplayCapturedAchievementPageState();
}

class _DisplayCapturedAchievementPageState
    extends State<DisplayCapturedAchievementPage> {
  final AchievementController _achievementController =
  AchievementController();

  final TextEditingController _descriptionField =
  TextEditingController(text: 'New Description');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BetaFitness'),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Improved Image Display
              Image.file(
                File(widget.image.path),
                height: 400, // Adjust the image height
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              SizedBox(height: 16),
              // Reorganized Buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Retake'),
                  ),
                  SizedBox(width: 16),
                  // Styled Text Form Field
                  Expanded(
                    child: TextFormField(
                      controller: _descriptionField,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Description required';
                        }
                        return null;
                      },
                      style: TextStyle(
                        color: Colors.white, // Changed to white lettering
                        fontSize: 16,
                        fontWeight: FontWeight.normal,
                      ),
                      decoration: InputDecoration(
                        labelText: 'New Description',
                        labelStyle: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                            color: Colors.white, // Changed to white border
                            width: 2.0,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        hintText: 'Enter Description',
                        hintStyle: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 16),
                  // Styled Submit Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor,
                      textStyle: TextStyle(fontSize: 16),
                    ),
                    child: Text('Submit'),
                    onPressed: () async {
                      _achievementController.addAchievement(
                        Achievement(
                          dateCaptured: DateTime.now(),
                          description: _descriptionField.text,
                          image: base64Encode(await widget.image.readAsBytes()),
                        ),
                      );
                      widget.updateList();
                      Navigator.of(context).pop();
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
