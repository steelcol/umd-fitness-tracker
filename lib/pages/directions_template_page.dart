String url = 'https://www.google.com/maps/dir/?api=1&origin=' +
    currentLocation.latitude.toString() +
    ',' +
    currentLocation.longitude.toString() +
    ' &destination=' +
    lat.toString() +
    ',' +
    lon.toString() +
    '&travelmode=driving&dir_action=navigate';


void _launchURL(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}