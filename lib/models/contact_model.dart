import 'package:cloud_firestore/cloud_firestore.dart';

class ContactModel {
  String? userId;
  Timestamp? createAt;

  ContactModel({this.userId, this.createAt});

  Map<String, dynamic> toMap(ContactModel contactModel) {
    final map = <String, dynamic>{};

    map['userId'] = contactModel.userId;
    map['createAt'] = contactModel.createAt;

    return map;
  }

  ContactModel.formMap(Map<String, dynamic> map) {
    userId = map['userId'];
    createAt = map['createAt'];
  }
}
