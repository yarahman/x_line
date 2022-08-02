import 'package:cloud_firestore/cloud_firestore.dart';

class StatusModel {
  String? id;
  String? userId;
  String? status;
  String? imageUrl;
  Timestamp? createAt;
  // Map? likes;
  int? likeCount;
  int? commentNumber;
  StatusModel(
      {this.id,
      this.userId,
      this.status,
      this.imageUrl,
      this.createAt,
      // this.likes,
      this.likeCount = 0,
      this.commentNumber = 0});

  Map<String, dynamic> tomap(StatusModel statusModel) {
    final map = <String, dynamic>{};

    map['userId'] = statusModel.userId;
    map['status'] = statusModel.status;
    map['createAt'] = statusModel.createAt;
    map['likeCount'] = statusModel.likeCount;
    // map['like'] = statusModel.likes;
    map['commentNumber'] = statusModel.commentNumber;

    return map;
  }

  Map<String, dynamic> toMapWithImage(StatusModel statusModel) {
    final map = <String, dynamic>{};

    map['userId'] = statusModel.userId;
    map['status'] = statusModel.status;
    map['imageUrl'] = statusModel.imageUrl;
    map['createAt'] = statusModel.createAt;
    map['likeCount'] = statusModel.likeCount;
    // map['like'] = statusModel.likes;
    map['commentNumber'] = statusModel.commentNumber;

    return map;
  }

  StatusModel.formMap(Map<String, dynamic> mapData) {
    id = mapData['id'];
    userId = mapData['userId'];
    status = mapData['status'];
    imageUrl = mapData['imageUrl'];
    createAt = mapData['createAt'];
    likeCount = mapData['likeCount'];
    // likes = mapData['like'];
    commentNumber = mapData['commentNumber'];
  }
}
