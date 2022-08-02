import 'package:flutter/material.dart';

import '../../themes/app_colors.dart';
import '../../models/user_model.dart';
import '../custom/custom_page_route.dart';
import '../../screens/chat_screen.dart';

class PeopleTile extends StatelessWidget {
  PeopleTile(this.userModel);
  UserModel userModel;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () {
        Navigator.of(context).push(
          CustomPageRoute(
            child:  ChatScreen(userModel),
          ),
        );
      },
      leading: CircleAvatar(
        backgroundColor: Colors.orange,
        backgroundImage: NetworkImage(userModel.profileImage!),
      ),
      title: Text(
        userModel.name!,
        style: TextStyle(
          fontWeight: FontWeight.bold,
          color: AppColors.textDefultColor(),
        ),
      ),
      subtitle: Text(
        userModel.gender!,
        style: const TextStyle(color: Colors.grey),
      ),
      trailing: Container(
        height: 11,
        width: 11,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(
            50.0,
          ),
          color: Colors.green,
        ),
      ),
    );
  }
}
