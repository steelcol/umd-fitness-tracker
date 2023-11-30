import 'dart:convert';

import 'package:BetaFitness/arguments/camera_arguments.dart';
import 'package:BetaFitness/utilities/routes.dart';
import 'package:BetaFitness/storage/singleton_storage.dart';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';

class AchievementPage extends StatefulWidget {
  AchievementPage({Key? key, required this.storage}) : super(key: key);

  final SingletonStorage storage;

  @override
  State<AchievementPage> createState() => _AchievementPageState();
}

class _AchievementPageState extends State<AchievementPage> {

  void updateAchievements() async {
    await widget.storage.updateAchievementData();
    this.setState(() {});
  }

  @override
  void initState() {
    // TODO: initialize your data or perform any necessary actions
    super.initState();
    setState(() {});
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
              child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  shrinkWrap: true,
                  itemCount: widget.storage.achievements.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding:
                      EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: SizedBox(
                        height: 120,
                        child: Card(
                          color: Theme.of(context).primaryColor,
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding (
                                      padding: EdgeInsets.all(10),
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Theme.of(context).primaryColor,
                                        ),
                                        onPressed: () {
                                          showDialog(
                                            useSafeArea: false,
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              content:  Image.memory(
                                                base64Decode(widget.storage.achievements[index].image),
                                                scale: .1,
                                              ),
                                            )
                                          );
                                        },
                                        child: Image.memory(base64Decode(widget.storage.achievements[index].image)),
                                      ),
                                    ),
                                    Padding(
                                        padding:
                                        EdgeInsets.symmetric(horizontal: 5)),
                                    Column(
                                      mainAxisAlignment:
                                      MainAxisAlignment.center,
                                      children: [
                                        Text(widget.storage
                                            .achievements[index].description),
                                        Text(widget.storage
                                            .achievements[index].dateCaptured.toString())
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
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
              updateList: updateAchievements,
            ),
          ).then((_) => setState(() {}));
        },
        backgroundColor: Theme.of(context).primaryColor,
        icon: const Icon(
          Icons.camera,
          color: Colors.white,
        ),
        label: const Text('log achievement',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
