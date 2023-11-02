import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class EventsPage extends StatefulWidget {
  const EventsPage({Key? key}) : super(key: key);

  State<EventsPage> createState() => _EventsPageState();
}

class _EventsPageState extends State<EventsPage>{
  final databaseReference = FirebaseFirestore.instance.collection('Events');
  final String createText = "Enter";
  final String showText = "Event";
  final myController = TextEditingController();

  @override
  void dispose() {
    myController.dispose();
    super.dispose();
  }

  void createEvent(){
    databaseReference.doc('ik6WOyW2vjga9AsfyGUc9D4jm5u2').update({"Events_Array": FieldValue.arrayUnion([myController.text])});
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
          TextField(
            controller: myController,
            decoration: InputDecoration(border: OutlineInputBorder(),
              hintText: 'Enter event',
            ),
          ),
          //TextField(
          //  controller: myController,
          //  decoration: InputDecoration(border: OutlineInputBorder(),
          //    hintText: 'Enter event description',
          //  ),
          //),
          TextButton(onPressed: createEvent, child: Text(createText)),
          TextButton(
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                        content: Text(myController.text)
                    );
                  },
                );
              },
              child: Text(showText)),
        ]
        ),
      ),
    );
  }
}