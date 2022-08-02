import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

import '../models/user_model.dart';
import '../others/strings.dart';

class AuthMethods with ChangeNotifier {
//* --------------------------------- global variables ------------------------------------------------------
  final firebaseAuth = FirebaseAuth.instance;
  final firebaseCloud = FirebaseFirestore.instance;
  final firebaseStorage = FirebaseStorage.instance;
  final userModel = UserModel();

//*######################## end global variabes #########################################

//? ------------------------------ getCurrentUser ------------------------------------------------------------

  User currentUser() {
    User? user = firebaseAuth.currentUser;
    return user!;
  }

//? -------------------------------------- singupUser method --------------------------------------------
//* just adding user to firebase authentication
//! not adding in database
  Future<User> singUpUser(String email, String password) async {
    try {
      UserCredential userCredential = await firebaseAuth
          .createUserWithEmailAndPassword(email: email, password: password);

      final newUser = userCredential.user;

      return newUser!;
    } catch (e) {
      print(e);
      rethrow;
    }
  }
//*################## end sing up user method ############################

//?--------------------------------------------------------- logInUser method ----------------------------------------------

  Future<void> logInUser(String email, String password) async {
    await firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }
//*##################################### end log In User method ######################

//? --------------------------------------------- adding user to data base method ------------------------------------------
//* this method responsible for adding user to firestore cloud
//* on user collection
  Future<void> addingUserToDb(
      {String? id,
      String? name,
      String? bio,
      String? profilePhoto,
      String? covarPhoto,
      String? gender}) async {
    try {
      var user = UserModel(
        id: id,
        name: name,
        bio: bio,
        profileImage: profilePhoto,
        covarImage: covarPhoto,
        gender: gender,
      );

      firebaseCloud.collection(usersCollection).doc(id).set(
            userModel.toMap(user),
          );
    } catch (e) {
      print(e);
      rethrow;
    }
  }

//*######################################## end of adding user to data base method #############################

//? -----------------------------------------------------------end upload covar image to db method-----------------------------------------------
  Future<String> uploadProfilePhotoToDb(File image, String userId) async {
    final imageName = basename(image.path);
    try {
      final ref = firebaseStorage.ref().child(userId);

      final upload =
          await ref.child(imageName).putFile(image).whenComplete(() {});

      final profilePicUrl = upload.ref.getDownloadURL();

      return profilePicUrl;
    } catch (e) {
      print(e);
      return 'image not uploaded';
    }
  }
//*######################################## end upload profile image to db method ########################################

//?----------------------------------------------------------- upload profile photo to db method --------------------------------------------------------------
  Future<String> uploadCovarPhotoToDb(File image, String userId) async {
    final imageName = basename(image.path);
    try {
      final ref = firebaseStorage.ref().child(userId);

      final upload =
          await ref.child(imageName).putFile(image).whenComplete(() {});

      final covarPicUrl = upload.ref.getDownloadURL();

      return covarPicUrl;
    } catch (e) {
      print(e);

      return 'covar pic is not uploaded , please try again';
    }
  }
//*################################################# end upload covar photo to db method ################################################
}
