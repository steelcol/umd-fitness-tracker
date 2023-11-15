import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ExerciseTemplatePage extends StatefulWidget {
  ExerciseTemplatePage(
      {Key? key,
      required this.exerciseName,
      required this.description,
      required this.videoURL})
      : super(key: key);

  final String exerciseName, description, videoURL;

  @override
  State<ExerciseTemplatePage> createState() => _ExerciseTemplatePageState();
}

class _ExerciseTemplatePageState extends State<ExerciseTemplatePage> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(
          widget.videoURL)!, // widget.videoURL
      flags: YoutubePlayerFlags(autoPlay: false, mute: false),
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BetaFitness'),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          YoutubePlayer(
              controller: _controller, showVideoProgressIndicator: true),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: Text(
              widget.exerciseName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Text(widget.description,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.normal,
              )
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width / 2,
              child: ElevatedButton.icon(
                onPressed: () {
                  // add funnctionality here
                },
                icon: Icon(Icons.add),
                label: Text(
                  'Add Exercise to Workout',
                  style: TextStyle(fontSize: 14),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
