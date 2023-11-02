import 'package:flutter/material.dart';

class EventItem {
  String name;
  DateTime date;
  TimeOfDay time;
  String location;

  EventItem({required this.name, required this.date, required this.time, required this.location});
}
