import 'package:cloud_firestore/cloud_firestore.dart';

class Event {
  String eventName;
  String description;
  DateTime date;
  GeoPoint location;

  Event({
    required this.eventName,
    required this.description,
    required this.date,
    required this.location
  });
}