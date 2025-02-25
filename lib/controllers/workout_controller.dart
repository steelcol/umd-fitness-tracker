import 'package:BetaFitness/models/saved_exercise_model.dart';
import 'package:BetaFitness/models/running_workout_model.dart';
import 'package:BetaFitness/models/weight_workout_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WorkoutController {
  final dbRef = FirebaseFirestore.instance.collection('Users');
  final userId = FirebaseAuth.instance.currentUser!.uid;

  // Public functions

  // TODO: Need to not use array union if we want duplicate values
  // Adds a workout to the database

  Future<void> addRunningWorkout(RunningWorkout workout) async {
     //every user must have an email
    final snapshot = await dbRef.doc(userId).collection('Workouts').get();
    if (snapshot.size == 0) {
      // Doesn't exists
      await dbRef
          .doc(userId)
          .collection('Workouts')
          .doc(userId)
          .set({'SavedWorkouts': FieldValue.arrayUnion([{
            'Distance': workout.distance,
            'WorkoutName': workout.workoutName,
            'Date': workout.date.millisecondsSinceEpoch,
            'Type': 'Cardio'
          }])});
    }
    else {
      await dbRef
          .doc(userId)
          .collection('Workouts')
          .doc(userId)
          .update({'SavedWorkouts': FieldValue.arrayUnion([{
            'Distance': workout.distance,
            'WorkoutName': workout.workoutName,
            'Date': workout.date.millisecondsSinceEpoch,
            'Type': 'Cardio'
          }])});
    }
  }

  Future<void> deleteRunningWorkout(RunningWorkout workout) async {
    final docRef = dbRef
        .doc(userId)
        .collection('Workouts')
        .doc(userId);

    docRef.update({
      'SavedWorkouts': FieldValue.arrayRemove([{
        'Distance': workout.distance,
        'WorkoutName': workout.workoutName,
        'Date': workout.date.millisecondsSinceEpoch,
        'Type': 'Cardio'
      }])});
  }

  Future<void> addWeightWorkout(List<SavedExercise> workoutToCreate, String workoutName) async {
    final snapshot = await dbRef.doc(userId).collection('Workouts').get();
    if (snapshot.size == 0) {
      if(workoutToCreate.length != 0) {
        try {
          List<Map<String, dynamic>> exercises = [];

          for (var exercise in workoutToCreate) {
            exercises.add({
             'ExerciseName': exercise.name,
             'RepCount': exercise.repCount,
             'SetCount': exercise.setCount
            });
          }
          await dbRef
              .doc(userId)
              .collection('Workouts')
              .doc(userId)
              .set({'SavedWorkouts': FieldValue.arrayUnion([{
                'WorkoutName': workoutName,
                'Type': 'Weight',
                'Exercises': exercises
              }])});
        }
        catch (e) {
          throw new Future.error("ERROR: $e");
        }
      }
      else {
        print('List is empty');
      }

    }
    else {
      if(workoutToCreate.length != 0) {
        try {
          List<Map<String, dynamic>> exercises = [];

          for (var exercise in workoutToCreate) {
            exercises.add({
             'ExerciseName': exercise.name,
             'RepCount': exercise.repCount,
             'SetCount': exercise.setCount
            });
          }
          await dbRef
              .doc(userId)
              .collection('Workouts')
              .doc(userId)
              .update({'SavedWorkouts': FieldValue.arrayUnion([{
                'WorkoutName': workoutName,
                'Type': 'Weight',
                'Exercises': exercises
              }])});
        }
        catch (e) {
          throw new Future.error("ERROR: $e");
        }
      }
      else {
        print('List is empty');
      }
    }
  }

  Future<void> deleteWeightWorkout(WeightWorkout workout) async {
    final docRef = dbRef
        .doc(userId)
        .collection('Workouts')
        .doc(userId);

    List<Map<String, dynamic>> removeList = [];

    workout.exercises.forEach((element) {
      removeList.add(
        {
          'ExerciseName': element.name, 
          'SetCount': element.setCount,
          'RepCount': element.repCount
        }
      );
    });
 
    docRef.update({
      'SavedWorkouts': FieldValue.arrayRemove([{
        'WorkoutName': workout.workoutName,
        'Type': 'Weight',
        'Exercises': removeList
      }])});
  }

}
