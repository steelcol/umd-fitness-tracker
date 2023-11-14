import 'package:BetaFitness/models/exercise_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WorkoutInformation {
  late List<Exercise> upperBodyExercises;
  late List<Exercise> lowerBodyExercises;
  late List<Exercise> coreExercises;
  late List<Exercise> stretchExercises;

  // Database shorthand
  final dbRef = FirebaseFirestore.instance.collection('WorkoutExercises');

  // Private constructor
  WorkoutInformation._create();

  // Async constructor initialization
  static Future<WorkoutInformation> create() async {
      // Call private constructor
      var info = WorkoutInformation._create();
      // Perform initialization
      await info._getUpperBodyExercises();
      await info._getLowerBodyExercises();
      await info._getCoreExercises();
      await info._getStretchExercises();

      return info;
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