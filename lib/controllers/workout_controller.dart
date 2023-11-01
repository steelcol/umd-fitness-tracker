import 'package:BetaFitness/models/running_workout_model.dart';
import 'package:BetaFitness/models/weight_workout_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WorkoutController {
  final dbRef = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;
  bool _runExist = false, _weightExist = false;

  List<RunningWorkout> runningWorkouts = [];
  List<WeightWorkout> weightWorkouts = [];

  // Setup function to grab workouts only if we have them
  // Will set us up for less database use and easier setup later on
 Future<void> setup() async{
    await _checkExist();

    if(_runExist) {
      await _getRunningWorkouts();
      print(runningWorkouts);
    }

    /*
    if(_weightExist) {
      _getWeightWorkouts();
      print(weightWorkouts);
    }
     */


  }

  Future<void> _checkExist() async {
    // Check if document exists for running workouts
    DocumentSnapshot<Map<String, dynamic>> document = await FirebaseFirestore
        .instance
        .collection("RunningWorkouts")
        .doc(user!.uid)
        .get();
    if(document.exists) {
      _runExist = true;
    }

    // Check if document exists for weight workouts
    document = await FirebaseFirestore
        .instance
        .collection("WeightWorkouts")
        .doc(user!.uid)
        .get();
    if(document.exists) {
      _weightExist = true;
    }
  }

  // Get running workouts
  Future<void> _getRunningWorkouts() async {
    // Grabs all the array and converts the FireStore data to custom objects
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

      print(runningWorkouts);
    }
    catch (e) {
      throw new Future.error("ERROR $e");
    }
  }

  Future<void> _getWeightWorkouts() async {
    await dbRef.collection("WeightWorkouts").doc(user!.uid).get().then((value) {
      List.from(value.data()!["Workouts"]).forEach((element) {
        WeightWorkout workout = new WeightWorkout(
          workoutName: element['WorkoutName']
        );

        weightWorkouts.add(workout);
      });
    });
  }
}