import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

import '../others/strings.dart';
import '../models/user_model.dart';
import '../models/status_model.dart';

class AccountMethods with ChangeNotifier {
//* ------------------------------------- global variabls --------------------------------------------------
  final firestore = FirebaseFirestore.instance;
  final fireStorage = FirebaseStorage.instance;
  StatusModel statusModel = StatusModel();

//?-------------------------------------------- fatchAccountDetails -----------------------------------------------

//* this methods for get data for current user "users" collection
  Future<UserModel> fatchAccountDetails(String currentUserId) async {
    try {
      final snapShot =
          await firestore.collection(usersCollection).doc(currentUserId).get();

      return UserModel.formMap(snapShot.data() as Map<String, dynamic>);
    } catch (e) {
      print(e);
      rethrow;
    }
  }
//*############################### end fatchAcccountDetails ################################

//? ------------------------------------------------- update covar photo method ------------------------------------------------
  Future<void> updateCovarImage(File image, String currentUserId) async {
    print('covar image method calling');
    String? imageUrl;
    final imageName = basename(image.path);
    final ref = fireStorage.ref().child(currentUserId);
    final upload =
        await ref.child(imageName).putFile(image).whenComplete(() {});

    final url = await upload.ref.getDownloadURL();

    imageUrl = url;

    await firestore
        .collection(usersCollection)
        .doc(currentUserId)
        .update({'covarImage': imageUrl});
  }

//*###################################### end update covar photo mehtod ##############################

//? ------------------------------------------------ update profile image method ------------------------------------------------------------
  Future<void> updateProfileImage(File image, String currentUserId) async {
    print('profile image method calling');
    String imageUrl;
    final imageName = basename(image.path);

    final ref = fireStorage.ref().child(currentUserId);

    final upload =
        await ref.child(imageName).putFile(image).whenComplete(() {});

    final url = await upload.ref.getDownloadURL();

    imageUrl = url;

    await firestore
        .collection(usersCollection)
        .doc(currentUserId)
        .update({'profileImage': imageUrl});
  }

//*############################# end update profile image method #############################

//? -------------------------------------------------- update user name method ---------------------------------------------------
  Future<void> updateUserName(String name, String currentUserId) async {
    await firestore
        .collection(usersCollection)
        .doc(currentUserId)
        .update({'name': name});
  }

//* ############################### end update user name method #################################

//? ---------------------------------------------------- update user gender method -----------------------------------------------------

  Future<void> updateGender(String gender, String currentUserId) async {
    await firestore
        .collection(usersCollection)
        .doc(currentUserId)
        .update({'gender': gender});
  }
//*############################## end update user gender method ################################

//?------------------------------------------------- update user bio method ---------------------------------------------------------

  Future<void> updateBioData(String bio, String currentUserId) async {
    await firestore
        .collection(usersCollection)
        .doc(currentUserId)
        .update({'bio': bio});
  }
//* ############################### end update user bio method ###################################

//? --------------------------------------------------- status upload to db -----------------------------------------------------------------

  Future<void> uploadPostToDb(
      {String? currentUserId,
      File? image,
      String? message,
      Map? likes,
      int? likeCount}) async {
    String? id;
    if (image != null) {
      final imageName = basename(image.path);
      final ref = fireStorage.ref().child(currentUserId!);

      final upload = await ref
          .child(postCollection)
          .child(imageName)
          .putFile(image)
          .whenComplete(() {});

      final imageUrl = await upload.ref.getDownloadURL();

      final model = StatusModel(
        userId: currentUserId,
        imageUrl: imageUrl,
        status: message,
        createAt: Timestamp.now(),
        likeCount: likeCount,
      );

      await firestore
          .collection(postCollection)
          .add(
            statusModel.toMapWithImage(
              model,
            ),
          )
          .then((value) {
        firestore
            .collection(postCollection)
            .doc(value.id)
            .update({'id': value.id});
      });
    } else {
      final model = StatusModel(
        userId: currentUserId,
        status: message,
        createAt: Timestamp.now(),
        likeCount: likeCount,
      );

      await firestore
          .collection(postCollection)
          .add(
            statusModel.tomap(model),
          )
          .then((value) {
        firestore
            .collection(postCollection)
            .doc(value.id)
            .update({'id': value.id});
      });
    }
  }
//*###################################### end of status upload to db mehtod ############################################
}
