import 'package:BetaFitness/arguments/info_arguments.dart';
import 'package:BetaFitness/arguments/storage_arguments.dart';
import 'package:BetaFitness/arguments/event_arguments.dart';
import 'package:BetaFitness/pages/active_workout_page.dart';
import 'package:BetaFitness/pages/exercise_template_page.dart';
import 'package:BetaFitness/pages/run_workout_page.dart';
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
import 'package:BetaFitness/pages/log_run_page.dart';

// Arguments
import 'package:BetaFitness/arguments/workout_arguments.dart';
import 'package:BetaFitness/arguments/exercise_template_arguments.dart';

// Class to handle our navigation, if you need to add arguments to your page
// add a arguments class (look at workout_arguments.dart) and look at the
// (case createWorkoutRoute:) to see how to pass arguments.
class RouteNavigator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homePageRoute:
        return MaterialPageRoute<HomePage>(builder: (context) => HomePage());
      case workoutPageRoute: 
      final infoArgs = settings.arguments as InfoArguments;
        return MaterialPageRoute<WorkoutPage>(builder: (context) => WorkoutPage(
          storage: infoArgs.storage,
          info: infoArgs.info
        ));
      case createWorkoutRoute:
        final args = settings.arguments as WorkoutArguments;
        return MaterialPageRoute<CreateWorkoutPage>(builder: (context) => CreateWorkoutPage(
            updateList: args.updateList,
            info: args.info
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
      case logRunPageRoute:
        final args = settings.arguments as WorkoutArguments;
        return MaterialPageRoute<LogRunPage>(builder: (context) => LogRunPage(
          updateList: args.updateList
        ));
      case runWorkoutPageRoute:
        final storageArgs = settings.arguments as StorageArguments;
        return MaterialPageRoute<RunWorkoutPage>(builder: (context) => RunWorkoutPage(
            storage: storageArgs.storage
        ));
      case listedEventsMapWorkoutsPageRoute:
        final eventArgs = settings.arguments as EventArguments;
        return MaterialPageRoute<ListedEventsMapWorkoutsPage>(builder: (context) => ListedEventsMapWorkoutsPage(
            eventStorage: eventArgs.eventStorage
        ));
      case exerciseTemplatePageRoute:
        final exerciseTemplateArgs = settings.arguments as ExerciseTemplateArguments;
        return MaterialPageRoute<ExerciseTemplatePage>(builder: (context) => ExerciseTemplatePage(
          exerciseName: exerciseTemplateArgs.exerciseName,
          description: exerciseTemplateArgs.description,
          videoURL: exerciseTemplateArgs.videoURL
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
