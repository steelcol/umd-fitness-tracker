import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';

class MessageController {
  // Public var
  late String? token;

  // Private var
  final _messaging = FirebaseMessaging.instance;
  late NotificationSettings _settings;

  void initiateSettings() async {
    _settings = await _messaging.requestPermission(
      alert: true,
      announcement: false,
      badge: true,
      carPlay: false,
      criticalAlert: false,
      provisional: false,
      sound: true,
    );

    if (kDebugMode) {
      print('Authroization Status=${_settings.authorizationStatus}');
    }
  }

  void getToken() async {
    token = await _messaging.getToken();

    final doc = FirebaseFirestore.instance
    .collection('Users')
    .doc(FirebaseAuth.instance.currentUser!.uid);

    doc.set({
       'token': token
    }, SetOptions(merge: true));

    if (kDebugMode) {
    print('Registration token=$token');
    }

  }
}
