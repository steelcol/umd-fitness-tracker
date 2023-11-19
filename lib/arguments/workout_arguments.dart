import 'package:BetaFitness/storage/workout_exercise_storage.dart';
// Class for route arguments when having required arguments for creating pages
// This class allows us to convert arguments in route_generator.dart to a
// more usable type.

class WorkoutArguments {
  final Function updateList;
  final Function addWorkout;
  final WorkoutInformation info;

  const WorkoutArguments({
    required this.updateList,
    required this.addWorkout,
    required this.info
  });
}
