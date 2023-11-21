import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';


class DirectionsTemplatePage extends StatefulWidget {
  DirectionsTemplatePage({
    Key? key,
  }) : super(key: key);

  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    throw UnimplementedError();
  }

  //widget.storage.events[$INDEX_VALUE].location

  String url = 'https://www.google.com/maps/dir/?api=1&origin=' +
      currentLocation.latitude.toString() +
      ',' +
      currentLocation.longitude.toString() +
      ' &destination=' +
      lat.toString() + //latitude
      ',' +
      lon.toString() + //longitude
      '&travelmode=driving&dir_action=navigate';


  void _launchURL(String url) async {
    if (await canLaunchUrl(url as Uri)) {
      await launchUrl(url as Uri);
    } else {
      throw 'Could not launch $url';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('BetaFitness'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
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