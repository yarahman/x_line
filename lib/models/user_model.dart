import 'package:flutter/cupertino.dart';

class UserModel with ChangeNotifier {
  String? id;
  String? name;
  String? profileImage;
  String? covarImage;
  String? gender;
  String? bio;

  UserModel(
      {this.id,
      this.name,
      this.profileImage,
      this.covarImage,
      this.gender,
      this.bio});

  Map<String, dynamic> toMap(UserModel model) {
    var map = <String, dynamic>{};

    map['id'] = model.id;
    map['name'] = model.name;
    map['profileImage'] = model.profileImage;
    map['covarImage'] = model.covarImage;
    map['gender'] = model.gender;
    map['bio'] = model.bio;

    return map;
  }

  UserModel.formMap(Map<String, dynamic> mapData) {
    id = mapData['id'];
    name = mapData['name'];
    profileImage = mapData['profileImage'];
    covarImage = mapData['covarImage'];
    gender = mapData['gender'];
    bio = mapData['bio'];
  }
}
