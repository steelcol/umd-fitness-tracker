import 'package:flutter_test/flutter_test.dart';
import 'package:fake_cloud_firestore/fake_cloud_firestore.dart';

void main() async {
  // Setup
  final instance = FakeFirebaseFirestore();
  await instance.collection('Users').doc('123456')
  .set({
    'email': 'test@test.com',
    'uid': '123456'
  });
  await instance.collection('Users')
    .doc('123456')
    .collection('CompletedWorkouts')
    .doc('123456')
    .set({
      'Workouts': [{
        'Date': 1700719200000,
        'UniqueId': '1',
        'Exercises': {
          'Curls': [5, 10, 15]
        }
      }]
    });

  // Actions
  

  // Assertions
}
