import 'package:BetaFitness/utilities/create_workout_arguments.dart';
import 'package:BetaFitness/utilities/routes.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:flutter/material.dart';
import 'package:BetaFitness/pages/home_page.dart';
import 'package:BetaFitness/pages/workout_page.dart';
import 'package:BetaFitness/pages/stats_page.dart';
import 'package:BetaFitness/pages/create_workout_page.dart';
import 'package:BetaFitness/pages/events_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;

// Class to handle our navigation, if you need to add arguments to your page
// add a arguments class (look at create_workout_arguments.dart) and look at the
// (case createWorkoutRoute:) to see how to pass arguments.
class RouteNavigator {

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case homePageRoute:
        return MaterialPageRoute<HomePage>(builder: (context) => HomePage());
      case workoutPageRoute:
        return MaterialPageRoute<WorkoutPage>(builder: (context) => WorkoutPage());
      case createWorkoutRoute:
        final args = settings.arguments as CreateWorkoutArguments;
        return MaterialPageRoute<CreateWorkoutPage>(builder: (context) => CreateWorkoutPage(pageType: args.pageType));
      case statsPageRoute:
        return MaterialPageRoute<StatsPage>(builder: (context) => StatsPage());
      case eventsPageRoute:
        return MaterialPageRoute<EventsPage>(builder: (context) => EventsPage());
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
                FirebaseFirestore.instance.collection('Users').add({
                  'uid': user.uid,
                  'email': user.email
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