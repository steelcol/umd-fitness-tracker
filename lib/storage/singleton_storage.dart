import 'package:BetaFitness/models/running_workout_model.dart';
import 'package:BetaFitness/models/event_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// This class holds our data as lists to be accessed later.
class SingletonStorage {
  // Getters do not have to be made they exists by default
  late List<RunningWorkout> runningWorkouts;
  late List<Event> events;

  // Private constructor
  SingletonStorage._create();

  // Async constructor initialization
  static Future<SingletonStorage> create() async {
    // Call private constructor
    var storage = SingletonStorage._create();
    await storage._getRunningWorkouts();
    await storage._getEvents();

    return storage;
  }

  // Public function
  Future<void> updateRunData() async {
    await _getRunningWorkouts();
  }

  Future<void> updateEventData() async {
    await _getEvents();
  }

  // Private functions

  // Grab running workouts
  Future<void> _getRunningWorkouts() async {
    // Check if doc exists then grab workouts
    bool runExists = await _checkExist('RunningWorkouts');

    if (runExists) {
      try {
        runningWorkouts = [];
        await FirebaseFirestore.instance
            .collection('RunningWorkouts')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get().then((value){
              List.from(value.data()!['Workouts']).forEach((element) {
                RunningWorkout workout = new RunningWorkout(
                  workoutName: element['WorkoutName'],
                  distance: element['Distance']
                );

                runningWorkouts.add(workout);
              });
        });
      }
      catch (e) {
        throw new Future.error("ERROR $e");
      }
    }
    else {
      runningWorkouts = [];
    }
  }

  Future<void> _getEvents() async {
    // Check if doc exists then grab events
    bool eventExists = await _checkExist('Events');

    if (eventExists) {
      try {
       events = [];
       await FirebaseFirestore.instance
          .collection('Events')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get().then((value) {
            List.from(value.data()!['Events_Array']).forEach((element) {
              Event event = new Event(
                eventName: element['EventName']
              );

              events.add(event);
            });
       });
      }
      catch (e) {
        throw new Future.error("ERROR $e");
      }
    }
    else {
      events = [];
    }
  }

  Future<bool> _checkExist(String collectionId) async {
    DocumentSnapshot<Map<String, dynamic>> document = await FirebaseFirestore
        .instance
        .collection(collectionId)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
    if(document.exists) {
      return true;
    }
    else {
      return false;
    }
  }
}