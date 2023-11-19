import 'package:BetaFitness/models/weight_workout_model.dart';
import 'package:BetaFitness/models/saved_exercise_model.dart';
import 'package:flutter/material.dart';

class WorkoutViewPage extends StatefulWidget {
  WorkoutViewPage({Key? key, required this.workout}) : super(key: key);

  final WeightWorkout workout;

  @override
  State<WorkoutViewPage> createState() => _WorkoutViewPageState();
}

class _WorkoutViewPageState extends State<WorkoutViewPage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
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
            Text(
              widget.workout.workoutName,
              style: TextStyle(
                color: Colors.white,
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ), 
            ), 
            Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Expanded(
                child: ListView.builder(
                  shrinkWrap: true,
                  itemCount: widget.workout.exercises.length,
                  itemBuilder: (context, index) {
                  return _buildExerciseCard(
                    widget.workout.exercises[index],
                    index
                  );
                },
              ),
            ),
          )
          ]
        )
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
              ],
            ),
          ),
        ],
      ),
    );
  }
}
