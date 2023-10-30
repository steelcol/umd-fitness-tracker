import 'package:flutter/material.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({Key? key}) : super(key: key);

  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage>{

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
        // Build events page here
      ),
    );
  }
}