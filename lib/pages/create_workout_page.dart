import 'package:BetaFitness/controllers/workout_controller.dart';
import 'package:BetaFitness/storage/workout_exercise_storage.dart';
import 'package:BetaFitness/models/exercise_model.dart';
import 'package:BetaFitness/models/saved_exercise_model.dart';
import 'package:flutter/material.dart';

// This page more than likely will need to be split up
class CreateWorkoutPage extends StatefulWidget {
  CreateWorkoutPage({Key? key,
    required this.updateList,
    required this.info})
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

  @override
  void initState() {
    upperBodyExercises = widget.info.upperBodyExercises;
    lowerBodyExercises = widget.info.lowerBodyExercises;
    stretchExercises = widget.info.stretchExercises;
    coreExercises = widget.info.coreExercises;
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("BetaFitness"),
          ),
          body: DefaultTabController(
            length: 4, 
            child: Center(
             child: ElevatedButton(
              onPressed: () {
                createdWorkout.add(
                  SavedExercise(
                   name: 'Squat',
                   repCount: 10,
                   setCount: 3
                  )
                );
                createdWorkout.add(
                  SavedExercise(
                    name: 'Leg Press',
                    repCount: 15,
                    setCount: 5
                  )
                );
                controller.addWeightWorkout(createdWorkout, 'Leg Day');
              },
              child: const Text('Add demo exercise'),
             )     
            )
          ),
        );
    }
  }
