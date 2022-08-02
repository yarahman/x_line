import 'package:cloud_firestore/cloud_firestore.dart';

class ChatModel {
  String? senderId;
  String? reciverId;
  String? message;
  String? imageUrl;
  String? type;
  Timestamp? createAt;

  ChatModel({
    this.senderId,
    this.reciverId,
    this.message,
    this.imageUrl,
    this.type,
    this.createAt,
  });

  Map<String, dynamic> toMap(ChatModel chatModel) {
    var mapData = <String, dynamic>{};

    mapData['senderId'] = chatModel.senderId;
    mapData['reciverId'] = chatModel.reciverId;
    mapData['message'] = chatModel.message;
    mapData['type'] = chatModel.type;
    mapData['createAt'] = chatModel.createAt;

    return mapData;
  }

  Map<String, dynamic> toMapWithImage(ChatModel chatModel) {
    var mapData = <String, dynamic>{};

    mapData['senderId'] = chatModel.senderId;
    mapData['reciverId'] = chatModel.reciverId;
    mapData['message'] = chatModel.message;
    mapData['type'] = chatModel.type;
    mapData['createAt'] = chatModel.createAt;
    mapData['imageUrl'] = chatModel.imageUrl;

    return mapData;
  }

  ChatModel.formMap(Map<String, dynamic> map) {
    senderId = map['senderId'];
    reciverId = map['reciverId'];
    message = map['message'];
    type = map['type'];
    createAt = map['createAt'];
    imageUrl = map['imageUrl'];
  }
}
