import 'package:BetaFitness/models/exercise_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WorkoutInformation {
  late List<Exercise> upperBodyExercises;
  late List<Exercise> lowerBodyExercises;
  late List<Exercise> coreExercises;
  late List<Exercise> stretchExercises;

  // Private instance variable to hold the singleton instance
  static WorkoutInformation? _instance;

  // Database shorthand
  final dbRef = FirebaseFirestore.instance.collection('WorkoutExercises');

  // Private constructor
  WorkoutInformation._create();

  // Async constructor initialization
  static Future<WorkoutInformation> create() async {
    // Call private constructor
    if (_instance == null) {
      // Create instance
      _instance = WorkoutInformation._create();

      // Perform initialization
      await _instance!._getUpperBodyExercises();
      await _instance!._getLowerBodyExercises();
      await _instance!._getCoreExercises();
      await _instance!._getStretchExercises();
    }

    return _instance!;
  }

  // Private functions

  // Function to grab exercises
  Future<void> _getUpperBodyExercises() async {
    try {
      upperBodyExercises = [];

      await dbRef.doc('UpperBody').get().then((value){
        List.from(value.data()!['Exercises']).forEach((element) {
          Exercise exercise = new Exercise(
            name: element['ExerciseName'],
            description: element['Description'],
            videoURL: element['VideoURL']
          );
          upperBodyExercises.add(exercise);
        });
      });
    }
    catch (e) {
      throw new Future.error("ERROR $e");
    }
  }

  Future<void> _getLowerBodyExercises() async {
    try {
      lowerBodyExercises = [];

      await dbRef.doc('LowerBody').get().then((value){
        List.from(value.data()!['Exercises']).forEach((element) {
          Exercise exercise = new Exercise(
              name: element['ExerciseName'],
              description: element['Description'],
              videoURL: element['VideoURL']
          );
          lowerBodyExercises.add(exercise);
        });
      });
    }
    catch (e) {
      throw new Future.error("ERROR $e");
    }
  }

  Future<void> _getCoreExercises() async {
    try {
      coreExercises = [];

      await dbRef.doc('Core').get().then((value){
        List.from(value.data()!['Exercises']).forEach((element) {
          Exercise exercise = new Exercise(
              name: element['ExerciseName'],
              description: element['Description'],
              videoURL: element['VideoURL']
          );
          coreExercises.add(exercise);
        });
      });
    }
    catch (e) {
      throw new Future.error("ERROR $e");
    }
  }

  Future<void> _getStretchExercises() async {
    try {
      stretchExercises = [];

      await dbRef.doc('Stretching').get().then((value){
        List.from(value.data()!['Exercises']).forEach((element) {
          Exercise exercise = new Exercise(
              name: element['ExerciseName'],
              description: element['Description'],
              videoURL: element['VideoURL']
          );
          stretchExercises.add(exercise);
        });
      });
    }
    catch (e) {
      throw new Future.error("ERROR $e");
    }
  }
}