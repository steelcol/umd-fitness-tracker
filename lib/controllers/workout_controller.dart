import 'package:BetaFitness/models/running_workout_model.dart';
import 'package:BetaFitness/models/weight_workout_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WorkoutController {
  final dbRef = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;
  bool runExist = false, weightExist = false;

  // Public functions
  Future<void> addRunningWorkout(RunningWorkout workout) async {
    await dbRef.collection("RunningWorkouts")
        .doc(user!.uid)
        .update({"Workouts": FieldValue.arrayUnion([{
          "Distance": workout.distance,
          "WorkoutName": workout.workoutName
        }])});
  }

  // Private functions

  // Check if document exists for both weights and running
  Future<void> checkExist() async {
    DocumentSnapshot<Map<String, dynamic>> document = await dbRef
        .collection("RunningWorkouts")
        .doc(user!.uid)
        .get();
    if(document.exists) {
      runExist = true;
    }

    // Check if document exists for weight workouts
    document = await FirebaseFirestore
        .instance
        .collection("WeightWorkouts")
        .doc(user!.uid)
        .get();
    if(document.exists) {
      weightExist = true;
    }
  }

  // Get running workouts
  Future<List<RunningWorkout>> getRunningWorkouts() async {
    // Grabs all the array and converts the FireStore data to custom objects
    List<RunningWorkout> runningWorkouts = [];
    try{
      await dbRef.collection("RunningWorkouts").doc(user!.uid).get().then((value) {
        List.from(value.data()!['Workouts']).forEach((element){
          RunningWorkout workout = new RunningWorkout(
              workoutName: element['WorkoutName'],
              distance: element['Distance']
          );

          runningWorkouts.add(workout);
        });
      });

      return runningWorkouts;
    }
    catch (e) {
      throw new Future.error("ERROR $e");
    }
  }

  /*
  // Get all the weight workouts
  Future<List<WeightWorkout>> getWeightWorkouts() async {
    await dbRef.collection("WeightWorkouts").doc(user!.uid).get().then((value) {
      List.from(value.data()!["Workouts"]).forEach((element) {
        WeightWorkout workout = new WeightWorkout(
          workoutName: element['WorkoutName']
        );

        weightWorkouts.add(workout);
      });
    });
  }
   */
}