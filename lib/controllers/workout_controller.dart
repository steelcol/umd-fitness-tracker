import 'package:BetaFitness/models/running_workout_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WorkoutController {
  final dbRef = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  // Public functions

  // Adds a workout to the database
  Future<void> addRunningWorkout(RunningWorkout workout) async {
    await dbRef.collection("RunningWorkouts")
        .doc(user!.uid)
        .update({"Workouts": FieldValue.arrayUnion([{
          "Distance": workout.distance,
          "WorkoutName": workout.workoutName
        }])});
  }
}