import 'package:BetaFitness/models/saved_exercise_model.dart';

class WeightWorkout {
  final String workoutName;
  final List<SavedExercise> exercises;

  WeightWorkout({
    required this.workoutName,
    required this.exercises
  });
}
