import 'dart:ffi';

import 'package:cloud_firestore/cloud_firestore.dart';

class CommentModel {
  String? userId;
  String? comment;
  String? imageUrl;
  Timestamp? createAt;

  CommentModel(
      {this.userId,
      this.comment,
      this.imageUrl,
      this.createAt,
      });

//this method for upload only text message into database
  Map<String, dynamic> toMap(CommentModel commentModel) {
    var mapData = <String, dynamic>{};

    mapData['userId'] = commentModel.userId;
    mapData['comment'] = commentModel.comment;
    mapData['createAt'] = commentModel.createAt;

    return mapData;
  }

// this method upload comment with image into database
  Map<String, dynamic> toMapWithImage(CommentModel commentModel) {
    var mapData = <String, dynamic>{};

    mapData['userId'] = commentModel.userId;
    mapData['comment'] = commentModel.comment;
    mapData['imageUrl'] = commentModel.imageUrl;
    mapData['createAt'] = commentModel.createAt;

    return mapData;
  }

  // this named constructor fetch data form database

  CommentModel.formMap(Map<String, dynamic> mapData) {
    userId = mapData['userId'];
    comment = mapData['comment'];
    imageUrl = mapData['imageUrl'];
    createAt = mapData['createAt'];
  }
}
