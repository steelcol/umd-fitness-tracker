import 'package:BetaFitness/storage/singleton_storage.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../controllers/event_controller.dart';
import '../models/event_model.dart';


class EventsPage extends StatefulWidget {
  const EventsPage({Key? key, required this.storage}) : super(key: key);

  final SingletonStorage storage;

  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage>{
  final databaseReference = FirebaseFirestore.instance.collection('Events');
  final String createText = "Enter";
  final String showText = "Event";
  DateTime selectedDate = DateTime.now();
    //controllers
  final nameController = TextEditingController();
  final descController = TextEditingController();
  final dateController = TextEditingController();

  //method creates event, adding to database
  void createEvent(){

    String name = nameController.text;
    String desc = descController.text;
    DateTime date = selectedDate;
    GeoPoint loc = GeoPoint(0, 0); // Change this

    // If you add events or add running workouts please make a controller to add the data correctly
    EventController controller = new EventController();
    Event event = new Event(eventName: name, description: desc, date: date, location: loc);

    controller.addEvent(event);
    // Then update the storage list
    print(event.date);
    widget.storage.updateEventData();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    descController.dispose();
    dateController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("BetaFitness"),
      ),
      body: Center(
        child: Column(
        // Build events page here
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          //event name text-field
          TextField(
            controller: nameController,
            decoration: InputDecoration(border: OutlineInputBorder(),
              hintText: 'Enter event',
            ),
          ),
          //event description text-field
          TextField(
            controller: descController,
            decoration: InputDecoration(border: OutlineInputBorder(),
              hintText: 'Enter event description',
            ),
          ),
          //datetime selector
          Text("${selectedDate.toLocal()}".split(' ')[0]),
          const SizedBox(height: 20.0,),
          ElevatedButton(
            onPressed: () => _selectDate(context),
            child: const Text('Select date'),
          ),
          //enter button
          ElevatedButton(onPressed: createEvent, child: Text(createText), ),
        ]
        ),
      ),
    );
  }
}