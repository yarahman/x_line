import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

import '../others/strings.dart';
import '../models/user_model.dart';

class PeopleMethods with ChangeNotifier {
  final fireStore = FirebaseFirestore.instance;

  Future<List<UserModel>> fetchAllUsers({required String currentUserId}) async {
    List<UserModel> users = [];
    QuerySnapshot snapshot = await fireStore.collection(usersCollection).get();

    for (var i = 0; i < snapshot.docs.length; i++) {
      if (snapshot.docs[i].id != currentUserId) {
        users.add(
          UserModel.formMap(
            snapshot.docs[i].data() as Map<String, dynamic>,
          ),
        );
      }
    }
    return users;
  }
}
