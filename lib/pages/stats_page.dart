import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:BetaFitness/models/running_workout_model.dart';

import '../storage/singleton_storage.dart';

// TODO: Implement Datetime values in database
// TODO: Populate X-axis based on Datetime values rather than DB element
// TODO: Implement weightlifting graph (state switch from dropdown)

class StatsPage extends StatefulWidget {
  const StatsPage({Key? key, required this.storage}) : super(key: key);

  final SingletonStorage storage;

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  List<String> selectedWorkoutType = ['Cardio', 'Weight'];
  String selectedExercise = "";

  @override
  void initState() {
    super.initState();
    widget.storage.updateRunData();
    // Initial dropdown display
    if (widget.storage.runningWorkouts.isNotEmpty){
      selectedExercise = widget.storage.runningWorkouts[0].workoutName;
    }
  }

  // Used to standardize y-axis of graph
  double getMaxY() {
  final distances = widget.storage.runningWorkouts.map((e) => e.distance).toList();

  return distances.isNotEmpty ? distances.reduce((value, element) => value > element ? value : element): 10;
  }

  // TODO: Implement with datetime values
  // Used to standardize x-axis of graph
  double getMaxX() {
    return widget.storage.runningWorkouts.length.toDouble();
  }

  // Get lists of exercise names
  List<String> getExerciseNames(String workoutType) {
    if (workoutType == 'Cardio') {
      return widget.storage.runningWorkouts.map((workout) => workout.workoutName).toList();

      // TODO: Implement weightlifting state
    // } else if (workoutType == 'Weightlifting') {
      //return widget.storage.weightWorkouts.map((workout) => workout.exerciseName).toList();
    }
    return [];
  }

  /// GRAPH DATA & DATA VISUAL FORMATTING ///
  LineChartBarData getChartData() {
    // Convert the list of RunningWorkout to LineChartBarData
    List<FlSpot> spots = widget.storage.runningWorkouts
        .asMap()
        .entries
        .map((entry) => FlSpot(entry.key.toDouble(), entry.value.distance))
        .toList();

    return LineChartBarData(
      spots: spots,

      /// GRAPH LINE ///
      isCurved: false,
      color: Colors.red,
      barWidth: 5,
      isStrokeCapRound: true, // Start cubic or round
      dotData: FlDotData(
        show: true,

        /// DOTS ///
        getDotPainter: (spot, percent, barData, index) =>
            FlDotCirclePainter(
              radius: 3,
              color: Colors.red,
              strokeWidth: 2.5,
              strokeColor: Colors.black,
            ),
      ),
      belowBarData: BarAreaData(show: false),
    );
  }

  /// BUILD ///
  @override
  Widget build(BuildContext context) {
    double maxX = getMaxX();
    double maxY = getMaxY();

    // TODO: Use for state switch on weightlifting graph
    // List<String> workoutNames = getWorkoutNames();

    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Stats'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              height: 400,
              padding: EdgeInsets.only(left: 10, right: 30, bottom: 30),
              child: LineChart(
                LineChartData(
                  backgroundColor: Colors.grey[500],
                  gridData: FlGridData(show: false),

                  /// AXIS TITLES FORMATTING ///
                  titlesData: FlTitlesData(
                    show: true,
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          const EdgeInsets geomPadding = EdgeInsets.only(top: 0, right: 10, bottom: 0);
                          if (value == 0) { // Put label on lowest val
                            return Padding(
                              padding: geomPadding,
                              /// Y-AXIS LABEL ///
                              child: Text(
                                'Distance (mi)',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            );
                          } else if (value >= maxY) { // Fix superimposed max Y-values
                            return SizedBox.shrink();
                          } else {
                            // Return the def widget for anything else
                            return Padding(
                              padding: geomPadding,
                              child: Text(
                                value.toInt().toString(),
                                style: TextStyle(
                                  color: Colors.white,
                                ),
                                textAlign: TextAlign.right,
                              ),
                            );
                          }
                        },
                        reservedSize: 70, // label spacing
                      ),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (double value, TitleMeta meta) {
                          if (value % 1 == 0) {
                            return Text(value.toInt().toString());
                          } else {
                            return SizedBox.shrink(); // Remove non-whole numbers
                          }
                        },
                        reservedSize: 30,
                      ),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false), // Remove top titles
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false), // Remove right titles
                    ),
                  ),

                  /// BORDER DATA & FORMATTING ///
                  borderData: FlBorderData(
                    show: true,
                    border: Border.all(
                      color: Colors.black,
                      width: 1,
                    ),
                  ),
                  minX: 0,
                  maxX: maxX,
                  minY: 0,
                  maxY: maxY,
                  lineBarsData: [getChartData()],
                ),

              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [

                /// DROP DOWN MENUS ///
                DropdownButton<String>(
                  value: selectedWorkoutType[0], // Display the first workout in the list
                  items: ['Cardio', 'Weight'].map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Text(type),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    // TODO: Weightlifting state change
                    if (newValue != null) {
                      setState(() {
                        selectedWorkoutType = [newValue];

                        // Update dropdown based on the selected workout type
                        var exerciseNames = getExerciseNames(newValue);
                        selectedExercise = exerciseNames.isNotEmpty ? exerciseNames.first : "";
                      });
                    }
                  },
                ),
                DropdownButton<String>(
                  value: selectedExercise.isNotEmpty ? selectedExercise : null, // If selectedExercise is not empty, use it as the current value, otherwise it's null
                  items: getExerciseNames(selectedWorkoutType[0]).map((String exerciseName) {
                    return DropdownMenuItem<String>(
                      value: exerciseName,
                      child: Text(exerciseName),
                    );
                  }).toList(),
                  onChanged: (String? newValue) {
                    setState(() {
                      selectedExercise = newValue ?? "";
                    });
                  },
                ),
      ]),

                /// DISTANCE TEXT BOX ///
                /// Will explode if not future'd as data needs to be loaded
                if (selectedWorkoutType[0] == 'Cardio' && selectedExercise.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: FutureBuilder<RunningWorkout?>(
                      future: _findWorkoutByName(selectedExercise),
                      builder: (BuildContext context, AsyncSnapshot<RunningWorkout?> snapshot) {
                        if (snapshot.connectionState == ConnectionState.done) {
                          if (snapshot.hasData) {
                            return Text(
                                'Distance: ${snapshot.data!.distance.toString()}',
                                 style:TextStyle(
                                   fontSize: 18,
                                 ),
                        );
                          } else {
                            return Text('No data found for this workout.');
                          }
                        } else {
                          return CircularProgressIndicator();
                        }
                      },
                    ),
                  ),
              ],
        ),
      ),
    );
  }

  //
  Future<RunningWorkout?> _findWorkoutByName(String workoutName) async {
    try {
      // Try to find workout by name
      return widget.storage.runningWorkouts.firstWhere(
            (workout) => workout.workoutName == workoutName,
      );
    } on StateError {
      // When no element found throw a null
      return null;
    }
  }
}

