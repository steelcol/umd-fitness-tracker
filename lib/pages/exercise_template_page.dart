import 'package:BetaFitness/models/saved_exercise_model.dart';
import 'package:BetaFitness/utilities/routes.dart';
import 'package:flutter/material.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class ExerciseTemplatePage extends StatefulWidget {
  ExerciseTemplatePage({
    Key? key,
    required this.exerciseName,
    required this.description,
    required this.videoURL,
    required this.updateList
  }) : super(key: key);

  final String exerciseName, description, videoURL;
  final Function updateList;

  @override
  State<ExerciseTemplatePage> createState() => _ExerciseTemplatePageState();
}

class _ExerciseTemplatePageState extends State<ExerciseTemplatePage> {
  late YoutubePlayerController _controller;

  @override
  void initState() {
    _controller = YoutubePlayerController(
      initialVideoId: YoutubePlayer.convertUrlToId(
        widget.videoURL,
      )!,
      flags: YoutubePlayerFlags(autoPlay: false, mute: false),
    );
    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addExercisePopup() {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    int setCount = 0;
    int repCount = 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              // overflow
              child: Column(
                mainAxisSize: MainAxisSize.min, // overflow
                children: <Widget>[
                  /// POP-UP TEXT FIELDS (3) ///

                  TextFormField(
                    decoration: InputDecoration(hintText: "Set Count"),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Set count required';
                      }
                      return null;
                    },
                    onSaved: (value) => setCount = int.parse(value!),
                  ),

                  TextFormField(
                    decoration: InputDecoration(hintText: "Rep Count"),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Rep count required';
                      }
                      return null;
                    },
                    onSaved: (value) => repCount = int.parse(value!),
                  ),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            /// POP-UP ADD BUTTON ///
            ElevatedButton(
              child: Text('Add Exercise'),
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  _formKey.currentState!.save();
                    SavedExercise newExercise = SavedExercise(
                      repCount: repCount,
                      setCount: setCount,
                      name: widget.exerciseName
                    );

                    widget.updateList(newExercise);
                    
                    // Bug with onGenerateRoute so need to pop 3 times.
                    for (int i = 0; i < 3; ++i) {
                      Navigator.pop(context);
                    }
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BetaFitness'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            YoutubePlayer(
              controller: _controller,
              showVideoProgressIndicator: true,
            ),
            SizedBox(height: 16),
            Text(
              widget.exerciseName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              widget.description,
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(height: 16),
            ElevatedButton.icon(
              onPressed: () {
                 _addExercisePopup();
              },
              icon: Icon(Icons.add),
              label: Text(
                'Add Exercise to Workout',
                style: TextStyle(fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 15, horizontal: 5),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
