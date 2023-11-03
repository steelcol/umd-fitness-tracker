import 'package:flutter/material.dart';
import 'event_item.dart';

class Event {
  String name;
  DateTime date;
  TimeOfDay time;
  String location;

  Event({required this.name, required this.date, required this.time, required this.location});
}

class ShowEventsList extends StatefulWidget {
  final List<Event> events;

  ShowEventsList({required this.events});

  @override
  _ShowEventsListState createState() => _ShowEventsListState();
}

class _ShowEventsListState extends State<ShowEventsList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Event List"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemCount: widget.events.length,
              itemBuilder: (context, index) {
                return EventItem(
                  name: widget.events[index].name,
                  date: widget.events[index].date,
                  time: widget.events[index].time,
                  location: widget.events[index].location,
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add event creation logic here
        },
        icon: Icon(
          Icons.add,
          color: Colors.white,
        ),
        label: Text(
          "Add Event",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}
