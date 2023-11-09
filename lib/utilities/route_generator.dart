import 'package:BetaFitness/arguments/storage_arguments.dart';
import 'package:BetaFitness/models/Save_Data_model.dart';
import 'package:BetaFitness/arguments/event_arguments.dart';
import 'package:BetaFitness/pages/active_workout_page.dart';
import 'package:BetaFitness/pages/listed_Events_Map_Workouts_page.dart';
import 'package:BetaFitness/utilities/routes.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

// Pages
import 'package:BetaFitness/pages/home_page.dart';
import 'package:BetaFitness/pages/workout_page.dart';
import 'package:BetaFitness/pages/stats_page.dart';
import 'package:BetaFitness/pages/create_workout_page.dart';
import 'package:BetaFitness/pages/events_page.dart';
import 'package:BetaFitness/pages/schedule_page.dart';

// Arguments
import 'package:BetaFitness/arguments/create_workout_arguments.dart';

// Class to handle our navigation, if you need to add arguments to your page
// add a arguments class (look at create_workout_arguments.dart) and look at the
// (case createWorkoutRoute:) to see how to pass arguments.
class RouteNavigator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homePageRoute:
        return MaterialPageRoute<HomePage>(builder: (context) => HomePage());
      case workoutPageRoute:
        final storageArgs = settings.arguments as StorageArguments;
        return MaterialPageRoute<WorkoutPage>(builder: (context) => WorkoutPage(
          storage: storageArgs.storage
        ));
      case createWorkoutRoute:
        final args = settings.arguments as CreateWorkoutArguments;
        return MaterialPageRoute<CreateWorkoutPage>(builder: (context) => CreateWorkoutPage(
            pageType: args.pageType,
            updateList: args.updateList
        ));
      case statsPageRoute:
        final storageArgs = settings.arguments as StorageArguments;
        return MaterialPageRoute<StatsPage>(builder: (context) => StatsPage(
          storage: storageArgs.storage
        ));
      case eventsPageRoute:
        final storageArgs = settings.arguments as StorageArguments;
        return MaterialPageRoute<EventsPage>(builder: (context) => EventsPage(
          storage: storageArgs.storage
        ));
      case activeWorkoutPageRoute:
        final storageArgs = settings.arguments as StorageArguments;
        return MaterialPageRoute<ActiveWorkoutPage>(builder: (context) => ActiveWorkoutPage(
        storage: storageArgs.storage
        ));
      case schedulePageRoute:
        final storageArgs = settings.arguments as StorageArguments;
        final storageDateTimeArgs = settings.arguments as StorageArguments;
        return MaterialPageRoute<SchedulePage>(builder: (context) => SchedulePage(
          storage: storageArgs.storage
        ));
      case listedEventsMapWorkoutsPageRoute:
        final eventArgs = settings.arguments as EventArguments;
        return MaterialPageRoute<ListedEventsMapWorkoutsPage>(builder: (context) => ListedEventsMapWorkoutsPage(
            eventStorage: eventArgs.eventStorage
        ));

        // User sign in and registration
      case signInRoute:
        return MaterialPageRoute<SignInScreen>(builder: (context) => SignInScreen(
          providers: [EmailAuthProvider()],
          actions: [
            AuthStateChangeAction<SignedIn>((context, state) {
              Navigator.of(context).popUntil((route) => route.isFirst);
              Navigator.pushReplacementNamed(context, homePageRoute);
            }),
            AuthStateChangeAction<UserCreated>((context, state) {
              final user = FirebaseAuth.instance.currentUser;

              if(user != null) {

                final doc = FirebaseFirestore.instance.collection('Users').doc(user.uid);
                doc.set({
                  "uid" : user.uid,
                  "email" : user.email
                });
              }
            })
          ],
        ));
      case profileRoute:
        return MaterialPageRoute<ProfileScreen>(builder: (context) => ProfileScreen(
          appBar: AppBar(
            title: const Text("BetaFitness"),
          ),
          providers: [EmailAuthProvider()],
          actions: [
            SignedOutAction((context) {
              Navigator.pushReplacementNamed(context, signInRoute);
            })
          ],
        ));
      default:
        return MaterialPageRoute<HomePage>(builder: (context) => HomePage());
    }
  }
}