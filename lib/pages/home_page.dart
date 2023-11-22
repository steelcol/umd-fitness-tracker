import 'dart:math';

import 'package:BetaFitness/arguments/storage_arguments.dart';
import 'package:BetaFitness/arguments/info_arguments.dart';
import 'package:BetaFitness/storage/singleton_storage.dart';
import 'package:BetaFitness/storage/workout_exercise_storage.dart';
import 'package:BetaFitness/utilities/routes.dart';
import 'package:flutter/material.dart';
import 'package:loading_indicator/loading_indicator.dart';

import '../models/save_data_model.dart';
import '../storage/event_storage.dart';

class HomePage extends StatefulWidget {
  HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late SingletonStorage storage;
  late WorkoutInformation info;
  bool _loading = true;
  late bool _todayHasEvent;
  late StorageArguments args;
  late InfoArguments infoArgs;
  //DateTime _focusedDay = DateTime.now();
  //DateTime? _selectedDay;
  EventStorage eventStorage = new EventStorage();

  void initializeSingletonStorage() async {
    storage = await SingletonStorage.create();
    info = await WorkoutInformation.create();
    args = StorageArguments(storage: storage);
    infoArgs = InfoArguments(storage: storage, info: info);
    _loading = false;
    _todayHasEvent = checkForEventToday();

    if (!mounted) return;
    setState(() {});
  }

  String getRandomFitnessTip() {
    final randGen = Random();
    String randTip = "";
    if (storage.fitnessTips.length > 0)
      randTip = storage.fitnessTips[randGen.nextInt(storage.fitnessTips.length - 1)].tip;
    return randTip;
  }

  bool checkForEventToday() {
    StoreDateTime home = new StoreDateTime(
        storage: storage,
        eventStorage: eventStorage
    );
    home.iterateEventItems(DateTime.now());
    if (home.getStoreCheck == true) {
      print("returned true"); // debuggin
      return true;
    }
    else  {
      print("returned false"); // debuggin
      return false;
    }
} //check if there is an event for today


  @override
  void initState() {
    initializeSingletonStorage();
    //checkForEventToday(); //run func to check if theres an event on today
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text("BetaFitness"),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, profileRoute),
            icon: Icon(Icons.account_circle_sharp),
          ),
        ],
      ),
      body: _loading
          ? Center(
        child: LoadingIndicator(
          indicatorType: Indicator.circleStrokeSpin,
          colors: [Theme
              .of(context)
              .primaryColor
          ],
        ),
      )
          : Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Card(
              elevation: 10,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: _todayHasEvent ? Column(
                  children: [
                    Text(
                      "Today's Activity",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 16),
                    // Add content related to today's activity here
                    Text("Events for today: " + eventStorage.storedEventName),
                    Text('Event Description: ' + eventStorage.storedEventDescription),
                  ],
                )
                : Column(
                  children: [
                    Text(
                      "Today's Activity",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                        "You have no events for today"
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(10),
              child:
                Card (
                  elevation: 5,
                  shape: BeveledRectangleBorder(
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child:
                    Padding(
                      padding: EdgeInsets.all(15),
                      child:
                        Text(
                            getRandomFitnessTip(),
                          style: TextStyle(
                            fontSize: 15,
                          ),
                          textAlign: TextAlign.center,
                        ),
                    )
                ),
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _buildActionButton(
                  icon: Icons.access_alarm_outlined,
                  label: "Schedule",
                  route: schedulePageRoute,
                ),
                _buildActionButton(
                  icon: Icons.data_usage,
                  label: "Stats",
                  route: statsPageRoute,
                ),
                _buildActionButton(
                  icon: Icons.fitness_center_sharp,
                  label: "Workout",
                  route: workoutPageRoute,
                  infoArgs: infoArgs
                ),
                _buildActionButton(
                  icon: Icons.camera,
                  label: "Achievements",
                  route: achievementsPageRoute,
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 15),
              child: _buildLongActionButton(
                icon: Icons.add,
                label: 'Start Workout',
                route: activeWorkoutPageRoute,
              ),
              ),
            _buildLongActionButton(
              icon: Icons.add,
              label: 'Log Run',
              route: runWorkoutPageRoute,
            )
          ],
        ),
      ),
    );
  }

  Widget _buildActionButton({required IconData icon, required String label, required String route, InfoArguments? infoArgs}) {
    return ElevatedButton(
      onPressed: () => Navigator.pushNamed(context, route, arguments: infoArgs == null ? args : infoArgs),
      style: ElevatedButton.styleFrom(
        backgroundColor: Theme.of(context).primaryColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.all(0), // Remove padding
        fixedSize: Size(80, 80), // Set a smaller fixed size for all buttons
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min, // Allow the column to shrink
        children: [
          Container(
            width: 40, // Adjust the icon size
            height: 40,
            child: Icon(icon, size: 24),
          ),
          SizedBox(height: 4), // Adjust the spacing
          Text(
            label,
            style: TextStyle(fontSize: 12), // Adjust the label font size
          ),
        ],
      ),
    );
  }

  Widget _buildLongActionButton({required IconData icon, required String label, required String route}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 11.4),
      child: ElevatedButton.icon(
        onPressed: () => Navigator.pushNamed(context, route, arguments: args), // TODO: workoutPageRoute => activeWorkoutPageRoute when dev start
        icon: Icon(icon),
        label: Text(label),
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          minimumSize: const Size(double.infinity, 70),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
    );
  }

}
