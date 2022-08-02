import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class GameMethods with ChangeNotifier {
  final fireStore = FirebaseFirestore.instance;

  Stream<QuerySnapshot> fetchAllGames() {
    return fireStore.collection('games').snapshots();
  }
}
