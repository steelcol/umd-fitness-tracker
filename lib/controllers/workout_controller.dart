import 'package:BetaFitness/models/running_workout_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WorkoutController {
  final dbRef = FirebaseFirestore.instance.collection('Users');
  final userId = FirebaseAuth.instance.currentUser!.uid;

  // Public functions

  // Adds a workout to the database
  Future<void> addRunningWorkout(RunningWorkout workout) async {
    await dbRef
        .doc(userId)
        .collection('Workouts')
        .doc(userId)
        .update({'SavedWorkouts': FieldValue.arrayUnion([{
          'Distance': workout.distance,
          'WorkoutName': workout.workoutName,
          'Type': 'Cardio'
        }])});
  }

  Future<void> deleteRunningWorkout(int idx) async {
    final docRef = dbRef.doc(userId).collection('Workouts').doc(userId);
    final snapshot = await docRef.get();
    final list = snapshot['Workouts'] as List;

    list.removeAt(idx);

    docRef.set({'Workouts': list});
  }
}