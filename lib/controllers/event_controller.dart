import 'package:BetaFitness/models/event_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventController {
  final dbRef = FirebaseFirestore.instance.collection('Users');
  final userId = FirebaseAuth.instance.currentUser!.uid;

  // Public Functions

  // Adds an event to the database
  Future<void> addEvent(Event event) async {
    final snapshot = await dbRef.doc(userId).collection('Events').get();
    if (snapshot.size == 0) {
      await dbRef
          .doc(userId)
          .collection('Events')
          .doc(userId)
          .set({"EventList": FieldValue.arrayUnion([{
            "EventName": event.eventName,
            "Description": event.description,
            "Date": event.date.millisecondsSinceEpoch,
            "Location": event.location
      }])});
    }
    else {
      await dbRef
          .doc(userId)
          .collection('Events')
          .doc(userId)
          .update({"EventList": FieldValue.arrayUnion([{
            "EventName": event.eventName,
            "Description": event.description,
            "Date": event.date.millisecondsSinceEpoch,
            "Location": event.location
      }])});
    }
  }
}
