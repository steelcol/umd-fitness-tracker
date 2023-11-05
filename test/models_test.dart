import 'package:flutter_test/flutter_test.dart';
import 'package:BetaFitness/models/weight_workout_model.dart';
import 'package:BetaFitness/models/running_workout_model.dart';
import 'package:BetaFitness/controllers/workout_controller.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

void main() async {
  // Setup
  final instance = FakeFirebaseFirestore();
  await instance.collection('Users').add({
    'email': 'test@test.com',
    'uid': '123456'
  });
  await instance.collection('RunningWorkouts').add({
    'Workouts': [
      {'Distance': '26.3', 'WorkoutName': 'Marathon'}
    ]
  });
  // Actions
  /*
  test("Checks to make sure can be received through controller functions",
          () =>
  );
   */

  // Assertions
}