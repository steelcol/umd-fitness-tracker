import 'package:BetaFitness/models/running_workout_model.dart';
import 'package:BetaFitness/models/weight_workout_model.dart';
import 'package:BetaFitness/models/event_model.dart';
import 'package:BetaFitness/models/saved_exercise_model.dart';
import 'package:BetaFitness/models/completed_workout_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:BetaFitness/models/fitness_tip_model.dart';
import 'package:BetaFitness/models/achievement_model.dart';

// This class holds our data as lists to be accessed later.
class SingletonStorage {
  // Getters do not have to be made they exists by default
  late List<RunningWorkout> runningWorkouts;
  late List<WeightWorkout> weightWorkouts;
  late List<CompletedWorkout> completedWorkouts; 
  late List<Event> events;
  late List<FitnessTip> fitnessTips;
  late List<Achievement> achievements;

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
    await storage._getCompletedWorkouts();
    await storage._getAchievements();

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

  Future<void> updateCompletedData() async {
    await _getCompletedWorkouts();
  }

  Future<void> updateAchievementData() async {
    await _getAchievements();
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
              // Make list to add to exercises
              List<SavedExercise> exercises = [];
              // Need to declare here can't name in loop
              List<dynamic> elementExercises = element['Exercises'];
              elementExercises.forEach( (element) {
                SavedExercise exercise = new SavedExercise(
                  name: element['ExerciseName'],
                  setCount: element['SetCount'],
                  repCount: element['RepCount']
                );
                exercises.add(exercise);
              });
              WeightWorkout workout = new WeightWorkout(
                workoutName: element['WorkoutName'],
                exercises: exercises
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

  Future<void> _getCompletedWorkouts() async {
    // Check if doc exists then grab events
    bool eventExists = await _checkExist('CompletedWorkouts');

    if (eventExists) {
      try {
       completedWorkouts = [];

       await dbRef
       .doc(userId)
       .collection('CompletedWorkouts')
       .doc(userId)
       .get().then((value) {
         List.from(value.data()!['Workouts']).forEach((element) {
            // Make list to add to exercises
            Map<String, List<int>> loggedExercises = {};
            Map<String, dynamic> tempList = element['Exercises'];
              tempList.forEach( (exercise, weights) {
                List<int> weightList = [];
                weights.forEach( (value) {
                  weightList.add(value);
                });
                loggedExercises[exercise] = weightList;
            });

           CompletedWorkout workout = new CompletedWorkout(
            uuid: element['UniqueId'],
            date: DateTime.fromMillisecondsSinceEpoch(element['Date']),
            exerciseWeights: loggedExercises,
           );

           completedWorkouts.add(workout);
         });
       });
      }
      catch (e) {
        throw new Future.error("ERROR $e");
      }
    }
    else {
      completedWorkouts = [];
    }
  }

  Future<void> _getAchievements() async {
    // Check if exists then grab achievements
    bool achievementExists = await _checkExist('Achievements');

    if (achievementExists) {
      try {
        achievements = [];

        await dbRef
            .doc(userId)
            .collection('Achievements')
            .doc(userId)
            .get().then((value) {
           List.from(value.data()!['AchievementList']).forEach((element) {
             Achievement achievement = new Achievement(
                 dateCaptured: DateTime.fromMillisecondsSinceEpoch(element['Date']),
                 description: element['Description'],
                 image: element['Image']
             );
             achievements.add(achievement);
           });
        });
      }
      catch (e) {
        throw new Future.error("ERROR $e");
      }
    } else {
      achievements = [];
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
