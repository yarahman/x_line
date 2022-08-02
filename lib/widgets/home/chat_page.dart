import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../chat_screen/chat_item.dart';
import '../../providers/chat_methods.dart';
import '../../providers/auth_methods.dart';
import '../../themes/app_colors.dart';
import '../../models/contact_model.dart';

class ChatPage extends StatefulWidget {
  const ChatPage({Key? key}) : super(key: key);

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  @override
  Widget build(BuildContext context) {
    final chatMethods = Provider.of<ChatMethods>(context, listen: false);
    final authMethod = Provider.of<AuthMethods>(context, listen: false);
    return SafeArea(
      child: Column(
        children: [
          const Text(
            'Chats',
            style: TextStyle(
              color: AppColors.defautlColor,
              fontSize: 30.0,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(
            height: 10.0,
          ),
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: chatMethods.fetchingAllContact(
                  currentUserId: authMethod.currentUser().uid),
                  
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  final chatListData = snapshot.data;

                  return ListView.builder(
                    itemCount: chatListData!.docs.isEmpty
                        ? 0
                        : chatListData.docs.length,
                    itemBuilder: (context, index) {
                      final contact = ContactModel.formMap(
                        chatListData.docs[index].data() as Map<String, dynamic>,
                      );
                      return ChatItem(
                        contactModel: contact,
                      );
                    },
                  );
                }
                return Text(
                  'loading....',
                  style: TextStyle(
                      color: AppColors.textDefultColor(),
                      fontWeight: FontWeight.bold),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
