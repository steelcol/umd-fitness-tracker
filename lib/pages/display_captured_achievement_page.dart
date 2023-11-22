import 'dart:convert';

import 'package:BetaFitness/controllers/Achievement_controller.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:BetaFitness/models/achievement_model.dart';
import 'dart:io';

class DisplayCapturedAchievementPage extends StatefulWidget {
  DisplayCapturedAchievementPage({Key? key,
    required this.image,
    required this.updateList
  })
      : super(key: key);

  final XFile image;
  final Function updateList;

  @override
  State<DisplayCapturedAchievementPage> createState() =>
      _DisplayCapturedAchievementPageState();
}

class _DisplayCapturedAchievementPageState extends
      State<DisplayCapturedAchievementPage> {

  final String description = "";
  final AchievementController _achievementController = new AchievementController();

  final TextEditingController _descriptionField =
      TextEditingController(text: 'New Description');

  @override
  initState() {
    super.initState();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text('BetaFitness')
      ),
      body: Padding(
        padding: EdgeInsets.all(10),
        child: Column(
          children: [
            Image.file(File(widget.image.path)),
            Spacer(),
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Retake'),
                ),
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      TextFormField(
                        controller: _descriptionField,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Description required';
                          }
                          return null;
                        },
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.normal,
                        ),
                        decoration: InputDecoration(
                          constraints: BoxConstraints(
                            maxWidth: MediaQuery.of(context).size.width / 2,
                          ),
                          labelText: null,
                          labelStyle: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.normal,
                          ),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide.none,
                          ),
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: 'Enter Description',
                          hintStyle: TextStyle(
                            color: Colors.grey,
                            fontSize: 10,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        child: Text('Submit'),
                        onPressed: () async {
                          _achievementController.addAchievement(
                            new Achievement(
                              dateCaptured: DateTime.now(),
                              description: _descriptionField.text,
                              image: base64Encode(await widget.image.readAsBytes()),
                            )
                          );
                          widget.updateList();
                          Navigator.of(context).pop();
                          Navigator.of(context).pop();
                        }
                      ),
                    ]
                  ),
                ),
              ]
            ),
          ]
      ),
      ),
    );
  }
}