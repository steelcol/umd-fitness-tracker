import 'package:BetaFitness/models/event_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EventController {
  final dbRef = FirebaseFirestore.instance;
  final user = FirebaseAuth.instance.currentUser;

  // Public Functions

  // Adds an event to the database
  Future<void> addEvent(Event event) async {
    await dbRef.collection("Events")
        .doc(user!.uid)
        .update({"Events_Array": FieldValue.arrayUnion([{
          "EventName": event.eventName,
          "Description": event.description,
          "Date": event.date
    }])});
  }
}