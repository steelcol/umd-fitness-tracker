import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;
import 'event_item.dart';

class DataConverter {
  static Map<String, dynamic> eventItemToMap(EventItem event) {
    return {
      'name': event.name,
      'date': Timestamp.fromDate(event.date),
      'time': event.time,
      'location': event.location,
    };
  }

  static EventItem mapToEventItem(Map<String, dynamic> data) {
    return EventItem(
      name: data['name'],
      date: (data['date'] as Timestamp).toDate(),
      time: data['time'],
      location: data['location'],
    );
  }
}
