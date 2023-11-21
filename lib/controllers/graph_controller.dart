import 'dart:math';
import 'package:BetaFitness/storage/singleton_storage.dart';

class GraphController {

  // Public functions
  double getMaxXForRun(SingletonStorage storage) {
    return storage.runningWorkouts.length.toDouble();
  }

  DateTime getMaxXForWeights(SingletonStorage storage) {
    List<DateTime> dates = [];
    storage.completedWorkouts.forEach(  (workout) {
        dates.add(workout.date);
    });
    return dates.reduce((a, b) => 
      a.difference(DateTime.now()).abs() < b.difference(DateTime.now()).abs() 
      ? a : b
    );
  }

  double getMaxY(SingletonStorage storage, 
  String workoutType,
  [String? exerciseName]
  ) {
    switch(workoutType) {
      case 'Cardio':
        final distances = storage.runningWorkouts.map((e) => e.distance).toList();

        return distances.isNotEmpty 
        ? distances.reduce((value, element) => value > element ? value : element)
        : 10;
      case 'Weight':
        return getBestWeightsForExercise(storage, exerciseName!)
          .reduce(max)
          .toDouble(); 
      default: 
        return 0;
    }
  }

  List<int> getBestWeightsForExercise(SingletonStorage storage, 
  String exerciseKey
  ) {
    List<int> bestWeightsForExercise = [];

    storage.completedWorkouts.forEach( (workout) {
      bestWeightsForExercise.add(workout.exerciseWeights[exerciseKey]!.reduce(max));
    });

    return bestWeightsForExercise;
  }

  List<String> getExerciseNames(String workoutType, 
  String workoutName, 
  SingletonStorage storage
  ) {
    switch(workoutType) {
      case 'Cardio': 
        return storage.runningWorkouts.map( (workout) => workout.workoutName).toList();
      case 'Weight':
        List<String> exercises = [];
        storage.completedWorkouts.forEach( ( workout) {
          workout.exerciseWeights.keys.forEach( (exercise) {
            if (!exercise.contains(exercise)) {
              exercises.add(exercise);
            }
          });
        });
        return exercises;
      // Should not reach this but just in case
      default:
        return [];
    }
  }
}
