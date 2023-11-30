import 'dart:convert';
import 'package:BetaFitness/arguments/camera_arguments.dart';
import 'package:BetaFitness/controllers/achievement_controller.dart';
import 'package:BetaFitness/models/achievement_model.dart';
import 'package:BetaFitness/utilities/routes.dart';
import 'package:BetaFitness/storage/singleton_storage.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:intl/intl.dart';

class AchievementPage extends StatefulWidget {
  AchievementPage({Key? key, required this.storage}) : super(key: key);

  final SingletonStorage storage;

  @override
  State<AchievementPage> createState() => _AchievementPageState();
}

class _AchievementPageState extends State<AchievementPage> {
  final AchievementController _achievementController = AchievementController();

  Future<bool?> _confirmDeleteAchievement(Achievement achievement) async {
    return showDialog<bool?>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this achievement?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                _deleteAchievement(achievement);
                Navigator.of(context).pop(true);
              },
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deleteAchievement(Achievement achievement) async {
    await _achievementController.deleteAchievement(achievement);
    widget.storage.updateAchievementData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BetaFitness'),
      ),
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: const Text(
                'Achievements',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Expanded(
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: widget.storage.achievements.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 5, horizontal: 10),
                      child: SizedBox(
                        height: 120,
                        child: Card(
                          color: Theme.of(context).primaryColor,
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(10),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Theme.of(context)
                                              .primaryColor,
                                        ),
                                        onPressed: () {
                                          print("opens image later");
                                        },
                                        child: Image.memory(
                                            base64Decode(widget.storage
                                                .achievements[index].image)),
                                      ),
                                    ),
                                    Padding(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 5),
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          widget.storage
                                              .achievements[index]
                                              .description,
                                        ),
                                        Text(
                                          _formatDate(
                                            widget.storage
                                                .achievements[index]
                                                .dateCaptured,
                                          ),
                                        )
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                width: 40, // Adjust this width as needed
                                child: IconButton(
                                  onPressed: () async {
                                    bool? confirmed =
                                    await _confirmDeleteAchievement(
                                      widget.storage.achievements[index],
                                    );
                                    if (confirmed ?? false) {
                                      widget.storage.updateAchievementData();
                                    }
                                  },
                                  icon: Icon(Icons.delete, color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final cameras = await availableCameras();
          final usableCamera = cameras[0];
          Navigator.pushNamed(
            context,
            achievementCapturePageRoute,
            arguments: CameraArguments(
              camera: usableCamera,
              updateList: widget.storage.updateAchievementData,
            ),
          );
        },
        backgroundColor: Theme.of(context).primaryColor,
        icon: const Icon(
          Icons.camera,
          color: Colors.white,
        ),
        label: const Text(
          'Log Achievement',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return DateFormat('MMMM d, y hh:mm a').format(date);
  }
}
