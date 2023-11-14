import 'package:BetaFitness/controllers/active_workout_controller.dart';
import 'package:BetaFitness/storage/singleton_storage.dart';
import 'package:BetaFitness/controllers/workout_controller.dart';
import 'package:flutter/material.dart';

class WorkoutSearchPage extends StatefulWidget {
  WorkoutSearchPage({Key? key, required this.storage}) : super(key: key);

  final SingletonStorage storage;
  final ActiveWorkoutController controller = ActiveWorkoutController();

  @override
  State<WorkoutSearchPage> createState() => _WorkoutSearchPageState();
}

class _WorkoutSearchPageState extends State<WorkoutSearchPage> {

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}