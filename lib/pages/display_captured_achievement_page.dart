import 'dart:convert';

import 'package:BetaFitness/controllers/achievement_controller.dart';
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
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            physics: ScrollPhysics(),
            padding: EdgeInsets.all(5),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: viewportConstraints.maxHeight,
              ),
              child: ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.all(15),
                      child: Image.file(
                        File(widget.image.path),
                        width: viewportConstraints.maxWidth,
                        scale: 0.55,
                      ),
                    ),
                    Spacer(),
                    Column(
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
                                maxWidth: MediaQuery
                                    .of(context)
                                    .size
                                    .width * 2 / 3,
                              ),
                              labelText: null,
                              labelStyle: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.normal,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(2.0))
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.all(Radius.circular(2.0)),
                              ),
                              floatingLabelBehavior: FloatingLabelBehavior
                                  .always,
                              hintText: 'Enter Description',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 10,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10),
                            child: Row(
                                mainAxisSize: MainAxisSize.min,
                                mainAxisAlignment: MainAxisAlignment
                                    .spaceAround,
                                children: [
                                  Spacer(),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context).primaryColor,
                                    ),
                                    onPressed: () => Navigator.of(context).pop(),
                                    child: Text(
                                      'Retake',
                                    ),
                                  ),
                                  Spacer(),
                                  ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Theme.of(context).primaryColor,
                                    ),
                                    onPressed: () async {
                                      _achievementController.addAchievement(
                                          new Achievement(
                                            dateCaptured: DateTime.now(),
                                            description: _descriptionField
                                                .text,
                                            image: base64Encode(
                                                await widget.image
                                                    .readAsBytes()),
                                          )
                                      );
                                      widget.updateList();
                                      Navigator.of(context).pop();
                                      Navigator.of(context).pop();
                                    },
                                    child: Text('Submit'),
                                  ),
                                  Spacer(),
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
      ),
    );
  }
}
