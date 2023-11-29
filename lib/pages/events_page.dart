import 'package:BetaFitness/storage/singleton_storage.dart';
import 'package:BetaFitness/utilities/routes.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../arguments/storage_arguments.dart';
import '../controllers/event_controller.dart';
import '../models/event_model.dart';
import 'map_page.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({Key? key,
    required this.storage,
    required this.updatePage
  }) : super(key: key);

  final SingletonStorage storage;
  final Function updatePage;

  @override
  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage> {
  final databaseReference = FirebaseFirestore.instance.collection('Events');
  final String createText = "Create Event";
  DateTime selectedDate = DateTime.now();
  late double x = 0, y = 0;

  final nameController = TextEditingController();
  final descController = TextEditingController();

  void updateLocation(double latitude, double longitude) {
    setState(() {
      this.x = latitude;
      this.y = longitude;
    });
  }

  void createEvent() {
    String name = nameController.text;
    String desc = descController.text;
    DateTime date = selectedDate;
    GeoPoint loc = GeoPoint(x, y);

    EventController controller = EventController();
    Event event = Event(eventName: name, description: desc, date: date, location: loc);

    controller.addEvent(event);
    widget.storage.updateEventData();
    widget.updatePage();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Create Event"),
        backgroundColor: Theme.of(context).primaryColor,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              _buildTextField(nameController, 'Event Name'),
              const SizedBox(height: 16.0),
              _buildTextField(descController, 'Event Description'),
              const SizedBox(height: 16.0),
              _buildDateSelector(context),
              const SizedBox(height: 16.0),
              _buildLocationInfo(),
              const SizedBox(height: 16.0),
              _buildMapButton(),
              const SizedBox(height: 16.0),
              _buildActionButton(createEvent, createText),
              const SizedBox(height: 16.0),
              _buildActionButton(
                    () {
                  Navigator.pushNamed(
                    context,
                    directionsTemplatePageRoute,
                    arguments: StorageArguments(storage: widget.storage),
                  );
                },
                'Open Route',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String labelText) {
    return TextField(
      controller: controller,
      style: TextStyle(fontSize: 18),
      decoration: InputDecoration(
        hintText: labelText,
        hintStyle: TextStyle(color: Colors.grey),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Theme.of(context).primaryColor, width: 2.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.grey),
        ),
      ),
    );
  }

  Widget _buildDateSelector(BuildContext context) {
    return ElevatedButton(
      onPressed: () => _selectDate(context),
      style: ElevatedButton.styleFrom(
        primary: Theme.of(context).primaryColor,
        textStyle: TextStyle(fontSize: 18),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.calendar_today),
          SizedBox(width: 8.0),
          Text('Select date'),
        ],
      ),
    );
  }

  Widget _buildLocationInfo() {
    return Text(
      "Location: $x, $y",
      style: TextStyle(fontSize: 18, color: Colors.grey),
    );
  }

  Widget _buildMapButton() {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        primary: Theme.of(context).primaryColor,
        textStyle: TextStyle(fontSize: 18),
      ),
      onPressed: () => _push(InteractiveMapPage(updateLocation: updateLocation)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.map),
          SizedBox(width: 8.0),
          Text('Select location on the map'),
        ],
      ),
    );
  }

  Widget _buildActionButton(Function onPressed, String label) {
    return ElevatedButton(
      onPressed: () => onPressed(),
      style: ElevatedButton.styleFrom(
        primary: Theme.of(context).primaryColor,
        textStyle: TextStyle(fontSize: 18),
      ),
      child: Text(label),
    );
  }

  void _push(Widget page) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => page,
      ),
    );
  }
}
