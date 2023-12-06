import 'package:BetaFitness/controllers/workout_controller.dart';
import 'package:BetaFitness/storage/workout_exercise_storage.dart';
import 'package:BetaFitness/models/exercise_model.dart';
import 'package:BetaFitness/models/saved_exercise_model.dart';
import 'package:flutter/material.dart';

import '../arguments/search_arguments.dart';
import '../utilities/routes.dart';

// This page more than likely will need to be split up
class CreateWorkoutPage extends StatefulWidget {
  CreateWorkoutPage({Key? key, 
    required this.updateList, 
    required this.info,
    required this.addWorkout
    })
      : super(key: key);

  final Function updateList;
  final Function addWorkout;
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

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void updateList(SavedExercise exercise) {
    setState(() {
      createdWorkout.add(exercise);   
    });
  }


  @override
  void initState() {
    upperBodyExercises = widget.info.upperBodyExercises;
    lowerBodyExercises = widget.info.lowerBodyExercises;
    stretchExercises = widget.info.stretchExercises;
    coreExercises = widget.info.coreExercises;
    // TODO: implement initState
    super.initState();
  }

  /// BUILD ///
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BetaFitness"),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Container(
                child: TextFormField(
                  controller: _workoutNameField,
                  keyboardType: TextInputType.name,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Workout name required';
                    }
                    return null;
                  },
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
                      return _buildExerciseCard(createdWorkout[index], index);
                    } else {
                      // Actually return the correct button
                      return _buildActionButton(
                        icon: Icons.add,
                        label: 'Add Exercise',
                        route: workoutSearchPageRoute,
                        information: widget.info,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () async {
            if (_formKey.currentState!.validate()) {
              _formKey.currentState!.save();
              await widget.addWorkout(createdWorkout, _workoutNameField.text);
              widget.updateList();
              Navigator.pop(context);
            }
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

  Widget _buildActionButton({required IconData icon, required String label, required String route, required WorkoutInformation information
  }) {
    return ElevatedButton(
      onPressed: () {
        SearchArguments searchArgs = new SearchArguments(
          info: information,
          updateList: updateList,
        );
        Navigator.pushNamed(context, route, arguments: searchArgs);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.symmetric(vertical: 14),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Allow the row to shrink
        children: [
          Icon(icon, size: 24),
          SizedBox(width: 8),
          Text(label, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}



