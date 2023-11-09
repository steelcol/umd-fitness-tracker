
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
        title: Text(widget.eventStorage.storedEventName),
      )
    );
    // TODO: implement build
    throw UnimplementedError();
  }
}