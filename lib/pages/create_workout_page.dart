import 'package:BetaFitness/controllers/workout_controller.dart';
import 'package:BetaFitness/storage/workout_exercise_storage.dart';
import 'package:BetaFitness/models/exercise_model.dart';
import 'package:BetaFitness/models/saved_exercise_model.dart';
import 'package:flutter/material.dart';

// This page more than likely will need to be split up
class CreateWorkoutPage extends StatefulWidget {
  CreateWorkoutPage({Key? key, required this.updateList, required this.info})
      : super(key: key);

  final Function updateList;
  final WorkoutInformation info;

  @override
  State<CreateWorkoutPage> createState() => _CreateWorkoutPageState();
}

class _CreateWorkoutPageState extends State<CreateWorkoutPage> {
  WorkoutController controller = new WorkoutController();

  // List to submit to controller our exercise
  // Needs to be null here for controller
  List<SavedExercise> createdWorkout = [];

  // Holds our different exercises in enumerable lists
  late List<Exercise> upperBodyExercises;
  late List<Exercise> lowerBodyExercises;
  late List<Exercise> stretchExercises;
  late List<Exercise> coreExercises;


  final TextEditingController _workoutNameField =
      TextEditingController(text: 'New Workout Name');

  @override
  void initState() {
    upperBodyExercises = widget.info.upperBodyExercises;
    lowerBodyExercises = widget.info.lowerBodyExercises;
    stretchExercises = widget.info.stretchExercises;
    coreExercises = widget.info.coreExercises;
    // TODO: implement initState
    super.initState();
  }

  /// POP-UP ///
  void _addExercisePopup() {
    final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
    String exerciseName = '';
    int setCount = 0;
    int repCount = 0;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('New Exercise'),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              // overflow
              child: Column(
                mainAxisSize: MainAxisSize.min, // overflow
                children: <Widget>[
                  /// POP-UP TEXT FIELDS (3) ///
                  TextFormField(
                    decoration: InputDecoration(hintText: "Exercise Name"),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Exercise name required';
                      }
                      return null;
                    },
                    onSaved: (value) => exerciseName = value!,
                  ),

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
                  setState(() {
                    createdWorkout.add(SavedExercise(
                      name: exerciseName,
                      setCount: setCount,
                      repCount: repCount,
                    ));
                  });
                  Navigator.of(context).pop(); // Close pop-up
                }
              },
            ),
          ],
        );
      },
    );
  }

  /// BUILD ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BetaFitness"),
      ),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor,
                    Theme.of(context).primaryColor,
                  ],
                  stops: [0.0, 0.5, .8],
                ),
                borderRadius: BorderRadius.circular(10),
              ),
              child: TextField(
                controller: _workoutNameField,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
                decoration: InputDecoration(
                  labelText: null,
                  labelStyle: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide.none,
                  ),
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                  hintText: 'Enter Workout Name',
                  hintStyle: TextStyle(
                    color: Colors.grey,
                    fontSize: 16,
                  ),
                ),
              ),
            ),

            /// TITLE FIELD & EXERCISE CARD SPACING ///
            SizedBox(height: 14),

            /// DYNAMIC EXERCISE LIST ///
            Expanded(
              child: ListView.builder(
                itemCount: createdWorkout.length + 1,
                itemBuilder: (context, index) {
                  if (index < createdWorkout.length) {
                    return _buildExerciseCard(createdWorkout[index],
                        index); // Pass the exercise and index
                  } else {
                    /// ADD EXERCISE BUTTON (subset of list) ///
                    return ElevatedButton.icon(
                      onPressed: _addExercisePopup,
                      icon: Icon(Icons.add),
                      label: Text(
                        'Add Exercise',
                        style: TextStyle(fontSize: 18),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Theme.of(context).primaryColor,
                        foregroundColor: Colors.white,
                        padding: EdgeInsets.symmetric(vertical: 15),
                      ),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            // TODO: Add & sync workout with database
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.teal,
            foregroundColor: Colors.white,
            padding: EdgeInsets.symmetric(vertical: 15),
            textStyle: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          child: Text('Create Workout'),
        ),
      ),
    );
  }

  Widget _buildExerciseCard(SavedExercise exercise, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 2, // Width/color highlight
              color: Colors.white,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                Text(
                  "${index + 1}.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8), // Space from highlight to index
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        exercise.name,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "${exercise.setCount} sets X ${exercise.repCount} reps",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    /// REMOVE EXERCISES FROM LIST ///
                    setState(() {
                      createdWorkout.removeAt(index);
                    });
                  },
                  icon: Icon(Icons.delete, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
