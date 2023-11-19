import 'package:BetaFitness/storage/workout_exercise_storage.dart';

class SearchArguments {
  final WorkoutInformation info;
  final Function updateList;

   SearchArguments({
    required this.info,
    required this.updateList,
  });
}
