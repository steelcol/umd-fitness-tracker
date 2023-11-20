import 'package:flutter/material.dart';
import 'package:BetaFitness/storage/event_storage.dart';

class ListedEventsMapWorkoutsPage extends StatefulWidget {
  const ListedEventsMapWorkoutsPage({Key? key, required this.eventStorage}) : super(key: key);

  final EventStorage eventStorage;

  @override
  _ListedEventsMapWorkoutsPageState createState() => _ListedEventsMapWorkoutsPageState();
}

class _ListedEventsMapWorkoutsPageState extends State<ListedEventsMapWorkoutsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Events'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Scroll down to see more text boxes!',
              style: TextStyle(
                fontSize: 20.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20.0),
            buildEventInfo('Event:', widget.eventStorage.storedEventName),
            buildEventInfo('Description:', widget.eventStorage.storedEventDescription),
            buildEventInfo('Date:', widget.eventStorage.storedDate.toString()),
            buildTextBox('Text Box'),
            // Add more widgets as needed
          ],
        ),
      ),
    );
  }

  Widget buildEventInfo(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 18.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 4.0),
          Text(
            value,
            style: TextStyle(
              fontSize: 16.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget buildTextBox(String labelText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        decoration: InputDecoration(
          labelText: labelText,
          border: OutlineInputBorder(),
        ),
      ),
    );
  }
}
