import 'dart:core';

import 'package:geolocator/geolocator.dart';

import 'package:BetaFitness/utilities/route_generator.dart';
import 'package:BetaFitness/utilities/routes.dart';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart' hide EmailAuthProvider;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitDown,
    DeviceOrientation.portraitUp
  ]);

  var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale 
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

  runApp(BetaFitness());
}

class BetaFitness extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      // Here we initialize firebase
        future: Firebase.initializeApp(),
        builder: (context, snapshot) {
          // Check for errors
          if(snapshot.hasError) {
            // Print error for now
            print("Could not connect to FireBase");
          }
          // Completion here
          if(snapshot.connectionState == ConnectionState.done) {
            // Do our storage setup here once we connect to the database

            return MaterialApp(
              title: "BetaFitness",
              theme: ThemeData(
                primarySwatch: Colors.green,
              ),
              themeMode: ThemeMode.dark,
              darkTheme: ThemeData(brightness: Brightness.dark),
              // Routes us to initial page
              initialRoute: FirebaseAuth.instance.currentUser == null ? signInRoute : homePageRoute,
              // Generates our routes for our app
              onGenerateRoute: RouteNavigator.generateRoute,
            );
          }
          Widget loading = MaterialApp();
          return loading;
        }
    );
  }
}
