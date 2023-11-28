import 'package:BetaFitness/models/achievement_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AchievementController {
  final dbRef = FirebaseFirestore.instance.collection('Users');
  final userId = FirebaseAuth.instance.currentUser!.uid;

  Future<void> addAchievement(Achievement achievement) async { 
    final snapshot = await dbRef.doc(userId).collection('Achievements').get();
    if (snapshot.size == 0) {
      await dbRef
          .doc(userId)
          .collection('Achievements')
          .doc(userId)
          .set({"AchievementList": FieldValue.arrayUnion([{
            'Date': achievement.dateCaptured.millisecondsSinceEpoch,
            'Description': achievement.description,
            'Image': achievement.image,
          }])});
    }
    else {
      await dbRef
          .doc(userId)
          .collection('Achievements')
          .doc(userId)
          .update({"AchievementList": FieldValue.arrayUnion([{
            'Date': achievement.dateCaptured.millisecondsSinceEpoch,
            'Description': achievement.description,
            'Image': achievement.image,
          }])});
    }
  }
}
