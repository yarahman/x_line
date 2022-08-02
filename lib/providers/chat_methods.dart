import 'dart:io';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import '../models/chat_model.dart';
import '../others/strings.dart';
import '../models/contact_model.dart';

class ChatMethods with ChangeNotifier {
  final fireStore = FirebaseFirestore.instance;
  final fireStorage = FirebaseStorage.instance;
  ChatModel chatModel = ChatModel();
  ContactModel contactModel = ContactModel();

  //?  ---------------------------------------------- sending message to db ---------------------------------------------------------------------------

  Future<void> sendMessageToDb(
      {File? image,
      required String senderId,
      required String reciverId,
      String? message}) async {
    var imageUrl = '';
    if (image != null) {
      final imageName = basename(image.path);

      final ref = fireStorage.ref().child(senderId);

      final upload = await ref
          .child(chatCollection)
          .child(reciverId)
          .child(imageName)
          .putFile(image)
          .whenComplete(() {});

      imageUrl = await upload.ref.getDownloadURL();
    }

    if (image != null) {
      ChatModel model = ChatModel(
          createAt: Timestamp.now(),
          imageUrl: imageUrl,
          message: message ?? 'send a image',
          reciverId: reciverId,
          senderId: senderId,
          type: 'image');

      await fireStore
          .collection(chatCollection)
          .doc(senderId)
          .collection(reciverId)
          .add(
            chatModel.toMapWithImage(
              model,
            ),
          );

      addToSenderContact(currentUserId: senderId, reciverId: reciverId);
      addToReciverContact(reciverId: reciverId, currentUserId: senderId);
      await fireStore
          .collection(chatCollection)
          .doc(reciverId)
          .collection(senderId)
          .add(
            chatModel.toMapWithImage(
              model,
            ),
          );
    } else {
      ChatModel model = ChatModel(
        createAt: Timestamp.now(),
        message: message,
        reciverId: reciverId,
        senderId: senderId,
        type: 'text',
      );
      await fireStore
          .collection(chatCollection)
          .doc(senderId)
          .collection(reciverId)
          .add(
            chatModel.toMap(
              model,
            ),
          );

      addToSenderContact(currentUserId: senderId, reciverId: reciverId);
      addToReciverContact(reciverId: reciverId, currentUserId: senderId);

      await fireStore
          .collection(chatCollection)
          .doc(reciverId)
          .collection(senderId)
          .add(
            chatModel.toMap(
              model,
            ),
          );
    }
  }

//*############################################ end sending message to db method #####################################

//? ------------------------------------------------------------------- fetching message method ---------------------------------------------------------------------------

  Stream<QuerySnapshot> fetchMessage(
      {required String currentUserId, required String reciverId}) {
    return fireStore
        .collection(chatCollection)
        .doc(currentUserId)
        .collection(reciverId)
        .orderBy('createAt', descending: true)
        .snapshots();
  }

//* ####################################### end fetching message method ###############################################

// ? -------------------------------------------------------------- addding on sender  contact  method-----------------------------------------------------------------------------------------

  Future<void> addToSenderContact(
      {required String currentUserId, required String reciverId}) async {
    final senderData = await fireStore
        .collection(usersCollection)
        .doc(currentUserId)
        .collection('contacts')
        .doc(reciverId)
        .get();

    if (!senderData.exists) {
      ContactModel contactModel =
          ContactModel(createAt: Timestamp.now(), userId: reciverId);

      final model = contactModel.toMap(contactModel);

      await fireStore
          .collection(usersCollection)
          .doc(currentUserId)
          .collection(contactCollection)
          .doc(reciverId)
          .set(model);
    }
  }

//*########################################### end adding on sender contact method ############################################

//?---------------------------------------------------------------- adding on reciver contact -----------------------------------------------------------------
  Future<void> addToReciverContact(
      {required String reciverId, required String currentUserId}) async {
    final reciverData = await fireStore
        .collection(usersCollection)
        .doc(reciverId)
        .collection(contactCollection)
        .doc(currentUserId)
        .get();

    if (!reciverData.exists) {
      ContactModel contactModel =
          ContactModel(createAt: Timestamp.now(), userId: currentUserId);

      final model = contactModel.toMap(contactModel);

      await fireStore
          .collection(usersCollection)
          .doc(reciverId)
          .collection(contactCollection)
          .doc(currentUserId)
          .set(model);
    }
  }

  //*####################################### end addding on reciver contact method #####################################

//?------------------------------------------------- fething all contact method ------------------------------------------------------------------------
  Stream<QuerySnapshot> fetchingAllContact({required String currentUserId}) {
    return fireStore
        .collection(usersCollection)
        .doc(currentUserId)
        .collection(contactCollection)
        .snapshots();
  }

//* ############################# end fetching all contect method ########################################

//?----------------------------------------------- fetch last message method ----------------------------------------------------------------------------

  Stream<QuerySnapshot> fetchLastMessage(
      {required String currentUserId, required String reciverId})  {
    return fireStore
        .collection(chatCollection)
        .doc(currentUserId)
        .collection(reciverId)
        .snapshots();
  }
}
