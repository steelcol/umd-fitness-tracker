import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'dart:math';

import '../storage/singleton_storage.dart';
import '../controllers/graph_controller.dart';
import '../models/running_workout_model.dart';
import '../models/completed_workout_model.dart';



class StatsPage extends StatefulWidget {
  final SingletonStorage storage;

  const StatsPage({Key? key, required this.storage}) : super(key: key);

  @override
  _StatsPageState createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final GraphController _controller = GraphController();
  DateTime currentDate = DateTime.now();
  String selectedExercise = "";
  bool _loading = true;

  void updatePersonalData() async {
    await widget.storage.updateRunData();
    await widget.storage.updateWeightData();
    await widget.storage.updateCompletedData();

    setState(() {
      _loading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    updatePersonalData();
    _tabController = TabController(length: 2, vsync: this);

    // Pick first exercise for dropdown menu initialization
    if (widget.storage.completedWorkouts.isNotEmpty && widget.storage.completedWorkouts.first.exerciseWeights.isNotEmpty) {
      selectedExercise = widget.storage.completedWorkouts.first.exerciseWeights.keys.first;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _changeMonth(bool isNext) {
    setState(() {
      if (isNext) {
        currentDate = DateTime(currentDate.year, currentDate.month + 1, 1);
      } else {
        currentDate = DateTime(currentDate.year, currentDate.month - 1, 1);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Workout Stats'),
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          /// Menu Tabs
          tabs: [
            Tab(text: 'Run Log'),
            Tab(text: 'Strength Log'),
          ],
        ),
      ),
      body: _loading
          ? Center(child: LoadingIndicator(indicatorType: Indicator.circleStrokeSpin, colors: [Theme.of(context).primaryColor
        ],
      ))
          : TabBarView(
        controller: _tabController,
        children: [
          _buildRunningTab(),
          _buildWeightTab(),
        ],
      ),
    );
  }

  Widget _buildRunningTab() {
    int year = currentDate.year;
    int month = currentDate.month;

    double maxX = _controller.getMaxX(year, month);
    double maxY = _controller.getMaxYRun(widget.storage, year, month);

    List<RunningWorkout> recentRuns = _controller.getRunsForMonth(widget.storage, year,month);

    return Column(
      children: [
        SizedBox(height: 10),

        /// R - Month selection
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_left),
              onPressed: () => _changeMonth(false),
            ),
            Text(
              DateFormat.yMMM().format(currentDate),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: Icon(Icons.arrow_right),
              onPressed: () => _changeMonth(true),
            ),
          ],
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height / 2,
          child: Container(
            padding: EdgeInsets.only(top: 10, left: 0, right: 10, bottom: 10),
            child: LineChart(
              LineChartData(
                backgroundColor: Colors.grey[500],

                /// R - Grid
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  drawHorizontalLine: true,
                  horizontalInterval: 2,

                  getDrawingVerticalLine: (value) {
                    return FlLine(
                      color: Colors.black.withOpacity(.25),
                      strokeWidth: 1,
                      dashArray: [5],
                    );
                  },

                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.black.withOpacity(.25),
                      strokeWidth: 1,
                      dashArray: [5],
                    );
                  },
                ),

                /// R - Titles
                titlesData: FlTitlesData(
                  show: true,
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 2,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        const EdgeInsets geomPadding = EdgeInsets.only(top: 0, right: 10, bottom: 0);

                        // Y-axis titling workaround
                        if (value == 0) {
                          return Padding(
                            padding: geomPadding,
                            child: Text(
                              'Distance (mi.)',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 8.5,
                                  fontWeight: FontWeight.bold),
                              textAlign: TextAlign.right,
                            ),
                          );
                        }

                        return value >= maxY
                            ? SizedBox.shrink() //
                            : Padding(
                                padding: geomPadding,
                                child: Text(
                                  value.toInt().toString(),
                                  style: TextStyle(
                                      /// R - Y label
                                      color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.right,
                                ),
                              );
                      },
                      reservedSize: 48,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      interval: 1, //
                      getTitlesWidget: (double value, TitleMeta meta) {
                        // X-axis days as two-digits
                        String dayString =
                            value.toInt().toString().padLeft(2, '0');
                        if (value >= 1 && value <= maxX) {
                          return Text(dayString,
                              style:
                                  /// R - X label
                                  TextStyle(color: Colors.white, fontSize: 8));
                        }
                        return SizedBox
                            .shrink(); // Hide labels outside current month
                      },
                      reservedSize: 30,
                    ),
                  ),
                  topTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  rightTitles:
                      AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.black, width: 1),
                ),
                minX: 1,
                maxX: maxX,
                minY: 0,
                maxY: maxY,
                lineBarsData: [_controller.getRunningChartData(widget.storage, year, month)],
              ),
            ),
          ),
        ),

        /// R - Recent Runs title & scrollable box
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Text(
            'Recent Runs',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),

              // No recent runs
              child: recentRuns.isEmpty
                  ? Center(
                      child: Text(
                        'No recent runs for this month',
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                    )

                  : SingleChildScrollView(
                  /// R - COLUMNS: {runName}, {distance}, {date}
                      padding: EdgeInsets.all(10),
                      child: Column(
                        children: recentRuns.map((run) {
                          return Padding(
                            padding: EdgeInsets.symmetric(vertical: 5),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    run.workoutName,
                                    textAlign: TextAlign.left,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                Expanded(
                                  flex: 2,
                                  child: Text(
                                    '${run.distance.toString()} mi',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                                Expanded(
                                  flex: 3,
                                  child: Text(
                                    DateFormat('yyyy-MM-dd').format(run.date),
                                    textAlign: TextAlign.right,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ),
                    ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWeightTab() {
    int year = currentDate.year;
    int month = currentDate.month;

    // Get list of completed workouts for dropdown menu
    List<String> exerciseList = widget.storage.completedWorkouts
        .expand((workout) => workout.exerciseWeights.keys)
        .toSet()
        .toList();

    // Match monthly date window with dates of completed exercises
    List<CompletedWorkout> recentSets = widget.storage.completedWorkouts
        .where((workout) =>
    workout.date.year == year && workout.date.month == month)
        .where(
            (workout) => workout.exerciseWeights.containsKey(selectedExercise))
        .toList();

    // Reselect exercise
    if (selectedExercise.isEmpty && exerciseList.isNotEmpty) {
      selectedExercise = exerciseList.first;
    }

    if (selectedExercise.isEmpty) {
      return Center(child: Text("No weight data available"));
    }

    double maxX = _controller.getMaxX(year, month);
    double maxY = _controller.getMaxYWeight(widget.storage, year, month, selectedExercise);

    return Column(
      children: [
        SizedBox(height: 10),
        /// W - Drop-Down Menu
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            DropdownButton<String>(
              value: selectedExercise,
              onChanged: (String? newValue) {
                setState(() {
                  selectedExercise = newValue!;
                });
              },
              items: exerciseList.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),

            /// W - Month Selection
            IconButton(
              icon: Icon(Icons.arrow_left),
              onPressed: () => _changeMonth(false),
            ),
            Text(
              DateFormat.yMMM().format(currentDate),
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            IconButton(
              icon: Icon(Icons.arrow_right),
              onPressed: () => _changeMonth(true),
            ),
          ],
        ),

        /// W - Weight Graph
        SizedBox(
          height: MediaQuery.of(context).size.height / 2,
          child: Container(
            padding: EdgeInsets.all(10),
            child: LineChart(
              LineChartData(

                /// W - Grid
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  drawHorizontalLine: true,
                  horizontalInterval: 15,
                  getDrawingHorizontalLine: (value) {
                    return FlLine(
                      color: Colors.white.withOpacity(.15),
                      strokeWidth: 1,
                      dashArray: [5],
                    );
                  },
                  getDrawingVerticalLine: (value) {
                    return FlLine(
                      color: Colors.white.withOpacity(.25),
                      strokeWidth: 1,
                      dashArray: [5],
                    );
                  },
                ),


                /// W - Titles
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text('${value.toInt()} lbs',
                            /// W - Y label
                            style:
                            TextStyle(color: Colors.white, fontSize: 8.5, fontWeight: FontWeight.bold));
                      },
                      interval: 15,
                      reservedSize: 40,
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (double value, TitleMeta meta) {
                        // X-axis days as two-digits
                        String dayString =
                        value.toInt().toString().padLeft(2, '0');
                        if (value >= 1 && value <= maxX) {
                          return Text(dayString,
                              /// W - X label
                              style:
                              TextStyle(color: Colors.white, fontSize: 8));
                        }
                        return SizedBox
                            .shrink(); // Hide labels outside current month
                      },
                      interval: 1,
                      reservedSize: 30,
                    ),
                  ),
                  rightTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  topTitles:
                  AxisTitles(sideTitles: SideTitles(showTitles: false)),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: Colors.black, width: 1),
                ),
                minX: 1,
                maxX: maxX,
                minY: 0,
                maxY: maxY,
                lineBarsData: [_controller.getWeightChartData(widget.storage, year, month, selectedExercise),],
              ),
            ),
          ),
        ),

        /// W - Recent Sets title & scrollable box
        Padding(
          padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
          child: Text(
            'Recent Sets',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: Padding(
            padding: EdgeInsets.all(10),
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),

              child: recentSets.isEmpty
                  ? Center(
                child: Text(
                  'No recent sets for this month',
                  style: TextStyle(fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              )

                  : SingleChildScrollView(
                padding: EdgeInsets.all(10),
                /// W - COLUMNS {exerciseName}, {weight}, {date}
                child: Column(
                  children: recentSets.map((set) {int maxWeight = set.exerciseWeights[selectedExercise] ?.reduce(max) ?? 0;
                  return Padding(
                    padding: EdgeInsets.symmetric(vertical: 5),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Text(
                            selectedExercise,
                            textAlign: TextAlign.left,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Expanded(
                          flex: 2,
                          child: Text(
                            '$maxWeight lbs',
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text(
                            DateFormat('yyyy-MM-dd').format(set.date),
                            textAlign: TextAlign.right,
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                      ],
                    ),
                  );
                  }).toList(),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

}
