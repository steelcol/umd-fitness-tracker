import 'package:BetaFitness/models/save_data_model.dart';
import 'package:BetaFitness/storage/event_list_storage.dart';
import 'package:flutter/material.dart';

import '../storage/event_storage.dart';

class ListedEventsMapWorkoutsPage extends StatefulWidget {
  const ListedEventsMapWorkoutsPage({Key? key, required this.storeDateTime}) : super(key: key);

  final StoreDateTime storeDateTime;


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
            buildEventInfo(
                'Event:', widget.storeDateTime.eventStorage.storedEventName),
            buildEventInfo('Description:',
                widget.storeDateTime.eventStorage.storedEventDescription),
            buildEventInfo('Date:',
                widget.storeDateTime.eventStorage.storedDate.toString()),
            // Add more widgets as needed
            Container(
              padding: EdgeInsets.symmetric(
                vertical: 10,
                horizontal: 10,
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.storeDateTime.eventStorage.listOfEvents
                    .length,
                itemBuilder: (context, index) {
                  print(widget.storeDateTime.eventStorage.listOfEvents.length);
                  return _buildEventCard(
                      widget.storeDateTime.eventStorage
                          .listOfEvents[index],
                      index
                  );
                },
              ),
            ),
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

  Widget _buildEventCard(EventStorage eventStorage, int index) {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Stack(
        children: [
          Positioned(
            left: 0,
            top: 0,
            bottom: 0,
            child: Container(
              width: 2, // Width/color highlight
              color: Colors.white,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(12),
            child: Row(
              children: [
                Text(
                  "${index + 1}.",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(width: 8), // Space from highlight to index
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Event Name: " + widget.storeDateTime.eventStorage.listOfEvents[index].storedEventName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Description: " + widget.storeDateTime.eventStorage.listOfEvents[index].storedEventDescription,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Date: ${widget.storeDateTime.eventStorage.listOfEvents[index].storedDate}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}