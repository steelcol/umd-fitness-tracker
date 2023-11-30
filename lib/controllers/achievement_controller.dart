import 'package:BetaFitness/models/achievement_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class AchievementController {
  final dbRef = FirebaseFirestore.instance.collection('Users');
  final userId = FirebaseAuth.instance.currentUser!.uid;


  Future<void> addAchievement(Achievement achievement) async {
    final DocumentReference docRef = dbRef
        .doc(userId)
        .collection('Achievements')
        .doc(userId);


    // Check if the document exists before updating
    DocumentSnapshot<Object?> document = await docRef.get();
    if (document.exists) {
      await docRef.update({
        "AchievementList": FieldValue.arrayUnion([
          {
            'Date': achievement.dateCaptured.millisecondsSinceEpoch,
            'Description': achievement.description,
            'Image': achievement.image,
          }
        ])
      });
    } else {
      // Create the document if it doesn't exist
      await docRef.set({
        "AchievementList": [
          {
            'Date': achievement.dateCaptured.millisecondsSinceEpoch,
            'Description': achievement.description,
            'Image': achievement.image,
          }
        ]
      });
    }
  }


  Future<void> deleteAchievement(Achievement achievement) async {
    final DocumentReference docRef = dbRef
        .doc(userId)
        .collection('Achievements')
        .doc(userId);


    // Check if the document exists before updating
    DocumentSnapshot<Object?> document = await docRef.get();
    if (document.exists) {
      await docRef.update({
        "AchievementList": FieldValue.arrayRemove([
          {
            'Date': achievement.dateCaptured.millisecondsSinceEpoch,
            'Description': achievement.description,
            'Image': achievement.image,
          }
        ])
      });
    }
  }
}
