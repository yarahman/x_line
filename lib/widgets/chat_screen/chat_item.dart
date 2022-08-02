import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../themes/app_colors.dart';
import '../../models/contact_model.dart';
import '../../providers/home_methods.dart';
import '../../models/user_model.dart';
import '../../providers/chat_methods.dart';
import '../../providers/auth_methods.dart';
import '../../models/chat_model.dart';
import '../../widgets/custom/custom_page_route.dart';
import '../../screens/chat_screen.dart';

class ChatItem extends StatelessWidget {
  ChatItem({this.contactModel});
  ContactModel? contactModel;

  @override
  Widget build(BuildContext context) {
    final homeMethod = Provider.of<HomeMethods>(context, listen: false);
    return Card(
      color: AppColors.widgetColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          20.0,
        ),
      ),
      child: StreamBuilder<DocumentSnapshot>(
        stream: homeMethod.fetchUserDetails(contactModel!.userId!),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userModel = UserModel.formMap(
                snapshot.data!.data() as Map<String, dynamic>);
            return ListTile(
              onTap: () {
                Navigator.of(context).push(
                  CustomPageRoute(
                    child: ChatScreen(
                      userModel,
                    ),
                  ),
                );
              },
              leading: CircleAvatar(
                  backgroundColor: Colors.orange,
                  backgroundImage: NetworkImage(userModel.profileImage!)),
              title: Text(
                userModel.name!,
                style: TextStyle(
                  color: AppColors.textDefultColor(),
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: LastMessageWidget(userModel: userModel),
              trailing: const Text(
                '1h ago',
                style: TextStyle(
                  color: Colors.grey,
                  fontWeight: FontWeight.bold,
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }
}

class LastMessageWidget extends StatelessWidget {
  LastMessageWidget({required this.userModel});

  UserModel userModel;

  @override
  Widget build(BuildContext context) {
    final chatMethods = Provider.of<ChatMethods>(context, listen: false);
    final authMethod = Provider.of<AuthMethods>(context, listen: false);
    return StreamBuilder<QuerySnapshot>(
      stream: chatMethods.fetchLastMessage(
          currentUserId: authMethod.currentUser().uid,
          reciverId: userModel.id!),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          var docList = snapshot.data!.docs;
          final chatModel =
              ChatModel.formMap(docList.last.data() as Map<String, dynamic>);
          return Text(
            chatModel.message!,
            style: const TextStyle(color: Colors.grey),
          );
        }
        return Text(
          "loading....",
          style: TextStyle(
            color: AppColors.textDefultColor(),
          ),
        );
      },
    );
  }
}
