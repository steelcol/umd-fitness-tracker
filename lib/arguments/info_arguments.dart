import 'package:BetaFitness/storage/singleton_storage.dart';
import 'package:BetaFitness/storage/workout_exercise_storage.dart';

class InfoArguments {
  final SingletonStorage storage;
  final WorkoutInformation info;

  const InfoArguments({
    required this.storage,
    required this.info
  });
}