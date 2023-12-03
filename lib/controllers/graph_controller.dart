import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'dart:math';

import 'package:BetaFitness/storage/singleton_storage.dart';
import '../models/running_workout_model.dart';
import '../models/completed_workout_model.dart';


class GraphController {

  /// 1.) Formats data for a RUNNING graph
  LineChartBarData getRunningChartData(SingletonStorage storage, int year, int month) {
    // Get list of running workouts within date window (monthly)
    List<RunningWorkout> monthlyWorkouts = storage.runningWorkouts
        .where((workout) =>
    workout.date.year == year && workout.date.month == month)
        .toList();

    // Create points for every run which adheres to date window
    List<FlSpot> spots = monthlyWorkouts.map((workout) {return FlSpot(workout.date.day.toDouble(), workout.distance);
    }).toList();

    return LineChartBarData(
        spots: spots,

        /// 1a.) Graph Line
        isCurved: true,
        color: Colors.red,
        barWidth: 3,
        isStrokeCapRound: true,
        // Start cubic or round

        /// 1b.) Graph Points
        dotData: FlDotData(
          show: true,
          getDotPainter: (spot, percent, barData, index) =>
              FlDotCirclePainter(
                radius: 1.5,
                color: Colors.red,
                strokeWidth: 2,
                strokeColor: Colors.black,
              ),
        ),

        /// 1c.) Area below curve
        belowBarData: BarAreaData(
          show: true,
          color: Colors.red.withOpacity(0.1),
        ));
  }

  /// 2.) Formats data for WEIGHTLIFTING graph
  LineChartBarData getWeightChartData(SingletonStorage storage, int year,
      int month, String exerciseKey) {

    // Get list of completed workouts within date window (monthly)
    List<CompletedWorkout> monthlyWorkouts = storage.completedWorkouts
        .where((workout) =>
    workout.date.year == year && workout.date.month == month)
        .toList();

    // Create point for each completed workout which adheres to date window
    List<FlSpot> spots = monthlyWorkouts.map((workout) {
      double weight = (workout.exerciseWeights[exerciseKey]?.reduce(max) ?? 0).toDouble();
      return FlSpot(workout.date.day.toDouble(), weight);
    }).toList();

    return LineChartBarData(
      spots: spots,

      /// 2a.) Graph Line
      isCurved: true,
      color: Colors.blueAccent,
      barWidth: 5,
      isStrokeCapRound: true,

      /// 2b.) Graph Points
      dotData: FlDotData(
        show: true,
      ),

      /// 2c.) Area below curve
      belowBarData: BarAreaData(
        show: true,
        color: Colors.blueAccent.withOpacity(0.1),
      ),
    );
  }

  /// 3.) Max X for chart (monthly interval)
  double getMaxX(int year, int month) {
    int daysInMonth = DateUtils.getDaysInMonth(year, month);
    return daysInMonth.toDouble();
  }

  /// 4a.) Max Y for RUNNING chart
  double getMaxYRun(SingletonStorage storage, int year, int month) {
    // Get list of runs within monthly window
    List<RunningWorkout> monthlyWorkouts = getRunsForMonth(storage, year, month);
    if (monthlyWorkouts.isEmpty) {
      return 0;
    }
    double maxY = monthlyWorkouts.map((e) => e.distance).reduce(max);
    return maxY;
  }

  /// 4b.) Max Y for WEIGHT chart
  double getMaxYWeight(SingletonStorage storage, int year, int month, String exerciseKey) {
    // Get list of completed workouts within monthly window
    List<CompletedWorkout> monthlyWorkouts = storage.completedWorkouts
        .where((workout) =>
    workout.date.year == year && workout.date.month == month)
        .toList();

    if (monthlyWorkouts.isEmpty) {
      return 0.0;
    }

    // Extract the maximum weight for the specified exercise (w/ key) from each workout, non-null
    List<double> maxWeights = monthlyWorkouts.map((workout) {
      return workout.exerciseWeights[exerciseKey]?.reduce(max).toDouble() ?? 0.0;
    }).toList();

    // Find the overall maximum weight
    double maxY = maxWeights.reduce(max);
    return maxY;
  }

  /// 5.) Get running workouts within monthly window
  List<RunningWorkout> getRunsForMonth(SingletonStorage storage, int year, int month) {
    return storage.runningWorkouts
        .where((workout) => workout.date.year == year && workout.date.month == month)
        .toList();
  }

}