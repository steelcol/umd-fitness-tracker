// Class for route arguments when having required arguments for creating pages
// This class allows us to convert arguments in route_generator.dart to a
// more usable type.
import 'package:BetaFitness/controllers/workout_controller.dart';

class CreateWorkoutArguments {
  final String pageType;
  final WorkoutController controller;
  final Function updateList;

  const CreateWorkoutArguments({
    required this.pageType,
    required this.controller,
    required this.updateList
  });
}