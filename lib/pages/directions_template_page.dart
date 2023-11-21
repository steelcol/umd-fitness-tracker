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


  void _launchURL(String url) async {

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    String long = position.longitude.toString();
    String lat = position.latitude.toString();

    String url = 'https://www.google.com/maps/dir/?api=1&origin=' +
        long + //current longitude
        ',' +
        lat + //current latitude
        ' &destination=' +
        widget.storage.events[0].location.toString() +
        '&travelmode=driving&dir_action=navigate';

    if (await canLaunchUrl(url as Uri)) {
      await launchUrl(url as Uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('BetaFitness'),
        ),
        body: Center(
          child: Column(

            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            ElevatedButton(onPressed: () => _launchURL, child: Text("enter"), ),
            ]
          ),
        ),
    );
  }




}
