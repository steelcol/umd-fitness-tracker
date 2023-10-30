import 'package:BetaFitness/utilities/create_workout_arguments.dart';
import 'package:BetaFitness/utilities/routes.dart';
import 'package:flutter/material.dart';
import 'package:BetaFitness/pages/home_page.dart';
import 'package:BetaFitness/pages/workout_page.dart';
import 'package:BetaFitness/pages/stats_page.dart';
import 'package:BetaFitness/pages/create_workout_page.dart';
import 'package:BetaFitness/pages/events_page.dart';

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
      default:
        return MaterialPageRoute<HomePage>(builder: (context) => HomePage());
    }
  }
}