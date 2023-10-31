import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseController {
  final databaseReference = FirebaseFirestore.instance.collection('Users');
  final user = FirebaseAuth.instance.currentUser;

  void getUserDocument() {
    //databaseReference
  }
}