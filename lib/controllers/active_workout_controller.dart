import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';

class ActiveWorkoutController {
  final dbRef = FirebaseFirestore.instance.collection('Users');
  final userId = FirebaseAuth.instance.currentUser!.uid;

  // Public functions
  void addCompletedWorkout(Map<String, List<int>> weightValues) async {
    final snapshot = await dbRef.doc(userId).collection('CompletedWorkouts').get();
    if (snapshot.size == 0) {
      DateTime now = DateTime.now();
      var uuid = Uuid();
      await dbRef
        .doc(userId)
        .collection('CompletedWorkouts')
        .doc(userId)
        .set({'Workouts': FieldValue.arrayUnion([{
          'Date': DateTime(now.year, now.month, now.day).millisecondsSinceEpoch,
          'UniqueId': uuid.v4(),
          'Exercises': weightValues 
        }])});
    }
    else {
      DateTime now = DateTime.now();
      var uuid = Uuid();
      await dbRef
        .doc(userId)
        .collection('CompletedWorkouts')
        .doc(userId)
        .update({'Workouts': FieldValue.arrayUnion([{
          'Date': DateTime(now.year, now.month, now.day).millisecondsSinceEpoch,
          'UniqueId': uuid.v4(),
          'Exercises': weightValues 
        }])});
    }
  }
}
