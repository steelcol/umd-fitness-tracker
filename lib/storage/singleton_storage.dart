import 'package:BetaFitness/models/running_workout_model.dart';
import 'package:BetaFitness/models/weight_workout_model.dart';
import 'package:BetaFitness/models/event_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:BetaFitness/models/fitness_tip_model.dart';

// This class holds our data as lists to be accessed later.
class SingletonStorage {
  // Getters do not have to be made they exists by default
  late List<RunningWorkout> runningWorkouts;
  late List<WeightWorkout> weightWorkouts;
  late List<Event> events;
  late List<FitnessTip> fitnessTips;

  // Database shorthand
  final dbRef = FirebaseFirestore.instance.collection('Users');
  final userId = FirebaseAuth.instance.currentUser!.uid;

  // Private constructor
  SingletonStorage._create();

  // Async constructor initialization
  static Future<SingletonStorage> create() async {
    // Call private constructor
    var storage = SingletonStorage._create();
    await storage._getRunningWorkouts();
    await storage._getWeightWorkouts();
    await storage._getEvents();
    await storage._getFitnessTips();

    return storage;
  }

  // Public function
  Future<void> updateRunData() async {
    await _getRunningWorkouts();
  }

  Future<void> updateWeightData() async {
    await _getWeightWorkouts();
  }

  Future<void> updateEventData() async {
    await _getEvents();
  }

  Future<void> updateFitnessData() async {
    await _getFitnessTips();
  }

  // Private functions

  // Grab running workouts
  Future<void> _getRunningWorkouts() async {
    // Check if doc exists then grab workouts
    bool runExists = await _checkExist('Workouts');

    if (runExists) {
      try {
        runningWorkouts = [];

        await dbRef
        .doc(userId)
        .collection('Workouts')
        .doc(userId)
        .get().then((value) {
          List.from(value.data()!['SavedWorkouts']).forEach((element) {
            if (element['Type'] == 'Cardio') {
              RunningWorkout workout = new RunningWorkout(
                  workoutName: element['WorkoutName'],
                  distance: element['Distance'].toDouble()
              );
              runningWorkouts.add(workout);
            }
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

  Future<void> _getWeightWorkouts() async {
    // Check if doc exists then grab events
    bool weightExists = await _checkExist('Workouts'); 

    if (weightExists) {
      try {
        weightWorkouts = [];

        await dbRef
        .doc(userId)
        .collection('Workouts')
        .doc(userId)
        .get().then((value) {
          List.from(value.data()!['SavedWorkouts']).forEach((element) {
            if (element['Type'] == 'Weight') {
              WeightWorkout workout = new WeightWorkout(
                workoutName: element['WorkoutName'],
                exercises: element['Exercises']
              );
              weightWorkouts.add(workout);
            }
          });
        });
      }
      catch (e) {
        throw new Future.error("ERROR $e");
      }
    }
    else {
      weightWorkouts = [];
    }
  }

  Future<void> _getEvents() async {
    // Check if doc exists then grab events
    bool eventExists = await _checkExist('Events');

    if (eventExists) {
      try {
       events = [];

       await dbRef
       .doc(userId)
       .collection('Events')
       .doc(userId)
       .get().then((value) {
         List.from(value.data()!['EventList']).forEach((element) {
           Event event = new Event(
             eventName: element['EventName'],
             description: element['Description'],
             date: DateTime.fromMillisecondsSinceEpoch(element['Date']),
             location: element['Location']
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

  Future<void> _getFitnessTips() async {
    //check if FitnessTips exists
    DocumentSnapshot<Map<String, dynamic>> document =
      await FirebaseFirestore
          .instance.collection('FitnessTips')
          .doc('Tips')
          .get();
    bool fitnessExists = document.exists;

    if (fitnessExists) {
      try {
        fitnessTips = [];

        await FirebaseFirestore
            .instance.collection('FitnessTips')
            .doc('Tips')
            .get().then((value) {
              List.from(value.data()!['FitnessTips']).forEach((element) {
                FitnessTip tip = new FitnessTip(tip: element.toString());
                fitnessTips.add(tip);
              });
            });
      } catch (e) {
        throw new Future.error("ERROR $e");
      }
    } else {
      fitnessTips = [];
    }
  }

  Future<bool> _checkExist(String collectionId) async {
    DocumentSnapshot<Map<String, dynamic>> document = await dbRef
        .doc(userId)
        .collection(collectionId)
        .doc(userId)
        .get();
    if(document.exists) {
      return true;
    }
    else {
      return false;
    }
  }


}
