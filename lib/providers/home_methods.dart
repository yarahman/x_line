import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';

import '../others/strings.dart';
import '../models/comment_model.dart';
import '../models/status_model.dart';

class HomeMethods with ChangeNotifier {
  final fireStore = FirebaseFirestore.instance;
  final firebaseStorage = FirebaseStorage.instance;

  CommentModel commentModel = CommentModel();

  //?---------------------------------------------- fetch all posts ---------------------------------------------------

  Stream<QuerySnapshot> fatchAllPosts() {
    return fireStore
        .collection(postCollection)
        .orderBy('createAt', descending: true)
        .snapshots();
  }

//*########################## end of fetch all posts ###############################

//? ------------------------------------------- fetch all user details -------------------------------------------------

  Stream<DocumentSnapshot> fetchUserDetails(String userId) {
    return fireStore.collection(usersCollection).doc(userId).snapshots();
  }
//*########################## end fetch all user details #############################

//?------------------------------------------------------------- update like counts ______________________________________
  Future<void> countLike(String docId, int likes) async {
    await fireStore
        .collection(postCollection)
        .doc(docId)
        .update({'likeCount': likes});
  }
//*######################################## end update like count #######################

//? ---------------------------------------------------------- send comment to data base -------------------------------------------

  Future<void> sendCommentToDb(
      {String? comment,
      File? image,
      required String currentUserId,
      required String docId}) async {
    if (image != null) {
      final imageName = basename(image.path);

      final ref = firebaseStorage.ref().child(currentUserId);

      final upload = await ref
          .child('comments')
          .child(imageName)
          .putFile(image)
          .whenComplete(() {});

      final url = await upload.ref.getDownloadURL();

      CommentModel model = CommentModel(
        comment: comment,
        imageUrl: url,
        userId: currentUserId,
        createAt: Timestamp.now(),
      );

      await fireStore
          .collection(postCollection)
          .doc(docId)
          .collection('comments')
          .add(commentModel.toMapWithImage(model));
    } else {
      CommentModel model = CommentModel(
        comment: comment,
        userId: currentUserId,
        createAt: Timestamp.now(),
      );

      await fireStore
          .collection(postCollection)
          .doc(docId)
          .collection('comments')
          .add(commentModel.toMap(model));
    }
  }
//*######################################## end sending comment to db ######################################

//?------------------------------------------------------ fetching all commnet form db -----------------------------------------------------

  Stream<QuerySnapshot> fetchingComment({required String docId}) {
    Stream<QuerySnapshot<Map<String, dynamic>>>? data;

    data = fireStore
        .collection(postCollection)
        .doc(docId)
        .collection('comments')
        .orderBy('createAt', descending: true)
        .snapshots();

    return data;
  }
//*########################################## end fetching all comment form bd #############################

//?------------------------------------------------------------- update like icon --------------------------------------------------------------------

  // Future<void> updateLikeIcon(
  //     {required String docId,
  //     required String currentUserId,
  //     required bool isLiked}) async {
  //   await fireStore
  //       .collection(postCollection)
  //       .doc(docId)
  //       .collection('likes')
  //       .doc(currentUserId)
  //       .set({currentUserId: isLiked});
  // }

//*######################################## end update like icon ##########################################

//?------------------------------------------------------------------- fetch liked post method --------------------------------------------------------------

  // Stream<DocumentSnapshot> fetchUserLikes(
  //     {required String docId, required String currentUserId}) {
  //   return fireStore
  //       .collection(postCollection)
  //       .doc(docId)
  //       .collection('likes')
  //       .doc(currentUserId)
  //       .snapshots();
  // }

//? ----------------------------------------------------------- fetch searched post item method ---------------------------------------------------------

  Future<List<StatusModel>> fetchSearchedPosts() async {
    List<StatusModel> postLists = [];
    QuerySnapshot snapshot = await fireStore
        .collection(postCollection)
        .orderBy('createAt', descending: true)
        .get();

    for (var i = 0; i < snapshot.docs.length; i++) {
      postLists.add(
        StatusModel.formMap(
          snapshot.docs[i].data() as Map<String, dynamic>,
        ),
      );
    }

    return postLists;
  }

//*####################################### end fetch seached post item method ##########################################

//? ---------------------------------------------------------------- update comment number method -----------------------------------------------------------------------

  Future<void> updateCommentNumber(
      {required String docId, required int commentNum}) async {
    await fireStore.collection(postCollection).doc(docId).update({
      'commentNumber': commentNum,
    });
  }

//*####################################### end update comment number method #######################################
}
