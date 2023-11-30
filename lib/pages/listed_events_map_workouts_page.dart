import 'package:BetaFitness/models/save_data_model.dart';
import 'package:BetaFitness/storage/event_list_storage.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:BetaFitness/storage/singleton_storage.dart';

class ListedEventsMapWorkoutsPage extends StatefulWidget {
  const ListedEventsMapWorkoutsPage({Key? key, required this.storeDateTime, required this.storage}) : super(key: key);

  final StoreDateTime storeDateTime;
  final SingletonStorage storage;

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
      body: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Add more widgets as needed
              Container(
                padding: EdgeInsets.symmetric(
                  vertical: 10,
                  horizontal: 10,
                ),
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
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
      ),
    );
  }

  Widget _buildEventCard(EventListStorage eventStorage, int index) {
    return InkWell(
        onTap: () async {
          //thome!!! on pressed right here, go to google maps
          Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
          String currentLng = position.longitude.toString();
          String currentLat = position.latitude.toString();
          String destinationLng = widget.storage.events[widget.storage.events.length-index-1].location.longitude.toString();
          String destinationLat = widget.storage.events[widget.storage.events.length-index-1].location.latitude.toString();

          final Uri googleMapsUrl = Uri.parse('https://www.google.com/maps/dir/?api=1&origin=' +
              currentLat + //current latitude
              ',' +
              currentLng + //current longitude
              ' &destination=' +
              destinationLat + //event latitude
              ',' +
              destinationLng + //event longitude
              '&travelmode=driving&dir_action=navigate');

          if (await canLaunchUrl(googleMapsUrl)) {
          await launchUrl(googleMapsUrl);
          } else {
          throw "Couldn't launch URL";
          }

        },
     child: Container(
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
                        "Event Name: " + widget.storeDateTime.eventStorage.listOfEvents[index].storedEventListName,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        "Description: " + widget.storeDateTime.eventStorage.listOfEvents[index].storedEventListDescription,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Date: ${widget.storeDateTime.eventStorage.listOfEvents[index].storedEventListDate}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Longitude: ${widget.storeDateTime.eventStorage.listOfEvents[index].storedGeoPointList.longitude}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Latitude: ${widget.storeDateTime.eventStorage.listOfEvents[index].storedGeoPointList.latitude}",
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
    )
    );
  }
}