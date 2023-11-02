import 'package:flutter/material.dart';
import 'package:BetaFitness/flutter_dart'
import 'package:flutter_test/flutter_test.dart';
import 'package:cloud_firestore/cloud_firestore.dart' show Timestamp;
import 'data_converter.dart';
import 'event_item.dart';

void main() {
  test('Test eventItemToMap', () {
    // Create an EventItem instance
    final eventItem = EventItem(
      name: 'Sample Event',
      date: DateTime(2023, 10, 30),
      time: TimeOfDay(hour: 10, minute: 0),
      location: 'Sample Location',
    );

    // Convert the EventItem to a map
    final result = DataConverter.eventItemToMap(eventItem);

    // Verify the map contains the expected values
    expect(result['name'], 'Sample Event');
    expect(result['date'], isA<Timestamp>());
    expect(result['time'], '10:00 AM');
    expect(result['location'], 'Sample Location');
  });

  test('Test mapToEventItem', () {
    // Create a map with Firestore-style data
    final data = {
      'name': 'Sample Event',
      'date': Timestamp.fromDate(DateTime(2023, 10, 30)),
      'time': '10:00 AM',
      'location': 'Sample Location',
    };

    // Convert the map to an EventItem
    final result = DataConverter.mapToEventItem(data);

    // Verify the EventItem object contains the expected values
    expect(result.name, 'Sample Event');
    expect(result.date, DateTime(2023, 10, 30));
    expect(result.time, TimeOfDay(hour: 10, minute: 0));
    expect(result.location, 'Sample Location');
  });
}
