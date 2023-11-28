import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:BetaFitness/storage/singleton_storage.dart';
import 'package:geolocator/geolocator.dart';

class DirectionsTemplatePage extends StatefulWidget {
  DirectionsTemplatePage({
    Key? key, required this.storage
  }) : super(key: key);

  final SingletonStorage storage;

  State<DirectionsTemplatePage> createState() => _DirectionsTemplatePageState();
}

class _DirectionsTemplatePageState extends State<DirectionsTemplatePage>{

  Future<void> checkPermission() async {
    var permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');

      }
    }
  }

  Widget build(BuildContext context) {
    print('button?');
    return Scaffold(
        appBar: AppBar(
          title: const Text('BetaFitness'),
        ),
        body: Center(
          child: Column(

              children: <Widget>[
          ListTile(
          title: Text("Launch Maps"),
          onTap: () async {

            Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
            String currentLng = position.longitude.toString();
            String currentLat = position.latitude.toString();
            String destinationLng = widget.storage.events[1].location.longitude.toString();
            String destinationLat = widget.storage.events[1].location.latitude.toString();

            final Uri googleMapsUrl = Uri.parse('https://www.google.com/maps/dir/?api=1&origin=' +
                currentLat + //current longitude
                ',' +
                currentLng + //current latitude
                ' &destination=' +
                destinationLat + //event longitude
                ',' +
                destinationLng + //event latitude
                '&travelmode=driving&dir_action=navigate');

            if (await canLaunchUrl(googleMapsUrl)) {
              await launchUrl(googleMapsUrl);
            } else {
              throw "Couldn't launch URL";
            }
          },
        ),
      ],
          ),
        ),
    );
  }

  }
