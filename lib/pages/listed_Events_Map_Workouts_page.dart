import 'package:flutter/material.dart';
import 'package:BetaFitness/storage/event_storage.dart';


class ListedEventsMapWorkoutsPage extends StatefulWidget {
  const ListedEventsMapWorkoutsPage({Key? key, required this.eventStorage}) : super(key: key);

  final EventStorage eventStorage;

  State<ListedEventsMapWorkoutsPage> createState() => _ListedEventsMapWorkoutsPageState();
}
class _ListedEventsMapWorkoutsPageState extends State<ListedEventsMapWorkoutsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Events: '),
      ),
      body: SingleChildScrollView(
        child: Padding(
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
              SizedBox(height: 20.0), //make function to find out how many events there are in selected day?
              Text('Event: ' + widget.eventStorage.storedEventName),
              Text('Description: ' + widget.eventStorage.storedEventDescription),
              Text('Date: ${widget.eventStorage.storedDate.toString()}'),
              Text('text'),
              Text('text'),
              Text('text'),
              Text('text'),
              Text('text'),
              Text('text'),
              Text('text'),
              Text('text'),
              Text('text'),
              Text('text'),
              Text('text'),
              Text('text'),
              Text('text'),
              Text('text'),
              Text('text'),
              Text('text'),
              Text('text'),
              Text('text'),
              Text('text'),
              Text('text'),
              Text('text'),
              Text('text'),
              Text('text'),
              Text('text'),
              Text('text'),
              Text('text'),
              Text('text'),
              Text('text'),
              Text('text'),
              Text('text'),
              Text('text'),
              Text('text'),
              Text('text'),
              Text('text'),
              Text('text'),
              Text('text'),
              Text('text'),
              Text('text'),
              Text('text'),
              Text('text'),
              Text('text'),
              Text('text'),
              Text('text'),
              Text('text'),
              buildTextBox('Text Box'),
              // Add more text boxes as needed
            ],
          ),
        ),
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




/*
class _ListedEventsMapWorkoutsPageState extends State<ListedEventsMapWorkoutsPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.eventStorage.storedEventName),
      )
    );
    //
    throw UnimplementedError();
  }
}
 */