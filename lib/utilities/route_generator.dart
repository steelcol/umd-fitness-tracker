import 'package:BetaFitness/arguments/events_page_arguments.dart';
import 'package:BetaFitness/arguments/home_page_arguments.dart';
import 'package:BetaFitness/arguments/info_arguments.dart';
import 'package:BetaFitness/arguments/storage_arguments.dart';
import 'package:BetaFitness/arguments/event_arguments.dart';
import 'package:BetaFitness/pages/active_workout_page.dart';
import 'package:BetaFitness/pages/run_workout_page.dart';
import 'package:BetaFitness/pages/listed_events_map_workouts_page.dart';
import 'package:BetaFitness/pages/search_workout_page.dart';
import 'package:BetaFitness/pages/select_workout_page.dart';
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
import 'package:BetaFitness/pages/exercise_template_page.dart';
import 'package:BetaFitness/pages/workout_view_page.dart';
import 'package:BetaFitness/pages/achievement_page.dart';
import 'package:BetaFitness/pages/achievement_capture_page.dart';
import 'package:BetaFitness/pages/display_captured_achievement_page.dart';

// Arguments
import 'package:BetaFitness/arguments/workout_arguments.dart';
import 'package:BetaFitness/arguments/workout_view_arguments.dart';
import 'package:BetaFitness/arguments/run_workout_arguments.dart';
import 'package:BetaFitness/arguments/camera_arguments.dart';
import 'package:BetaFitness/arguments/captured_achievement_arguments.dart';

import '../arguments/exercise_template_arguments.dart';
import '../arguments/search_arguments.dart';
import '../pages/directions_template_page.dart';

// Class to handle our navigation, if you need to add arguments to your page
// add a arguments class (look at workout_arguments.dart) and look at the
// (case createWorkoutRoute:) to see how to pass arguments.
class RouteNavigator {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homePageRoute:
        return MaterialPageRoute<HomePage>(builder: (context) => HomePage());
      case workoutPageRoute: 
      final args = settings.arguments as InfoArguments;
        return MaterialPageRoute<WorkoutPage>(builder: (context) => WorkoutPage(
          storage: args.storage,
          info: args.info
        ));
      case createWorkoutRoute:
        final args = settings.arguments as WorkoutArguments;
        return MaterialPageRoute<CreateWorkoutPage>(builder: (context) => CreateWorkoutPage(
            updateList: args.updateList,
            addWorkout: args.addWorkout,
            info: args.info
        ));
      case statsPageRoute:
        final args = settings.arguments as StorageArguments;
        return MaterialPageRoute<StatsPage>(builder: (context) => StatsPage(
          storage: args.storage
        ));
      case eventsPageRoute:
        final args = settings.arguments as EventPageArguments;
        return MaterialPageRoute<EventsPage>(builder: (context) => EventsPage(
            updatePage: args.updatePage,
            storage: args.storage
        ));
      case activeWorkoutPageRoute:
        final args  = settings.arguments as WorkoutViewArguments;
        return MaterialPageRoute<ActiveWorkoutPage>(builder: (context) => ActiveWorkoutPage(
          workout: args.workout
        ));
      case schedulePageRoute:
        final args = settings.arguments as EventPageArguments;
        return MaterialPageRoute<SchedulePage>(builder: (context) => SchedulePage(
          updatePage: args.updatePage,
          storage: args.storage
        ));
      case logRunPageRoute:
        final args = settings.arguments as RunWorkoutArguments;
        return MaterialPageRoute<LogRunPage>(builder: (context) => LogRunPage(
          updateList: args.updateList
        ));
      case runWorkoutPageRoute:
        final args = settings.arguments as StorageArguments;
        return MaterialPageRoute<RunWorkoutPage>(builder: (context) => RunWorkoutPage(
            storage: args.storage
        ));
      case workoutSearchPageRoute:
        final args = settings.arguments as SearchArguments;
        return MaterialPageRoute<WorkoutSearchPage>(builder: (context) => WorkoutSearchPage(
            info: args.info,
            updateList: args.updateList,
        ));
      case listedEventsMapWorkoutsPageRoute:
        final args = settings.arguments as EventArguments;
        return MaterialPageRoute<ListedEventsMapWorkoutsPage>(builder: (context) => ListedEventsMapWorkoutsPage(
            storeDateTime: args.storeDateTime, storage: args.storage,
        ));
      case exerciseTemplatePageRoute:
        final args = settings.arguments as ExerciseTemplateArguments;
        return MaterialPageRoute<ExerciseTemplatePage>(builder: (context) => ExerciseTemplatePage(
          exerciseName: args.exerciseName,
          description: args.description,
          videoURL: args.videoURL,
          updateList: args.updateList
        ));
      case savedWorkoutViewPageRoute: 
        final args = settings.arguments as WorkoutViewArguments;
        return MaterialPageRoute<WorkoutViewPage>(builder: (context) =>
          WorkoutViewPage(
           workout: args.workout, 
        ));
      case directionsTemplatePageRoute:
        final args = settings.arguments as StorageArguments;
        return MaterialPageRoute<DirectionsTemplatePage>(builder: (context) => DirectionsTemplatePage(
            storage: args.storage
        ));
      case achievementsPageRoute:
        final args = settings.arguments as StorageArguments;
        return MaterialPageRoute<AchievementPage>(builder: (context) =>
          AchievementPage(
            storage: args.storage,
        ));
      case achievementCapturePageRoute:
        final args = settings.arguments as CameraArguments;
        return MaterialPageRoute<AchievementCapturePage>(builder: (context) =>
          AchievementCapturePage(
            camera: args.camera,
            updateList: args.updateList,
        ));
      case displayCapturedAchievementPageRoute:
        final args = settings.arguments as CapturedAchievementArguments;
        return MaterialPageRoute<DisplayCapturedAchievementPage>(builder: (context) =>
          DisplayCapturedAchievementPage(
            image: args.image,
            updateList: args.updateList,
          ));
      case selectWorkoutPageRoute:
        final args = settings.arguments as StorageArguments;
        return MaterialPageRoute<SelectWorkoutPage>(builder: (context) =>
          SelectWorkoutPage(
          storage: args.storage,
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
