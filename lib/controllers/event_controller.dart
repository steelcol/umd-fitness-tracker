import 'package:BetaFitness/models/event_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventController {
  final dbRef = FirebaseFirestore.instance.collection('Users');
  final userId = FirebaseAuth.instance.currentUser!.uid;

  // Public Functions

  // Adds an event to the database
  Future<void> addEvent(Event event) async {
    await dbRef
        .doc(userId)
        .collection('Events')
        .doc(userId)
        .update({"EventList": FieldValue.arrayUnion([{
          "EventName": event.eventName,
          "Description": event.description,
          "Date": event.date.millisecondsSinceEpoch
    }])});
  }
}