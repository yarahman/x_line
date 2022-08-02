import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../themes/app_colors.dart';
import '../models/user_model.dart';
import '../widgets/chat_screen/chat_bubble.dart';
import '../providers/chat_methods.dart';
import '../providers/auth_methods.dart';
import '../models/chat_model.dart';

class ChatScreen extends StatefulWidget {
  ChatScreen(this.userModel);
  UserModel? userModel;

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  //* -------------------------------------------------------------- global variables ----------------------------------------------------------->

  var messageText = '';
  ChatMethods? chatMethods;
  AuthMethods? authMethods;
  File? image;
  final textEditorController = TextEditingController();
  var isLoading = false;

  //? ###################################### end global variables ######################################

  //* ---------------------------------------------------------- methods / functions ----------------------------------------------------------------->

  Future<void> sendMessageToDb() async {
    setState(() {
      isLoading = true;
    });

    textEditorController.clear();
    chatMethods!
        .sendMessageToDb(
      senderId: authMethods!.currentUser().uid,
      reciverId: widget.userModel!.id!,
      image: image,
      message: messageText,
    )
        .then((_) {
      setState(() {
        messageText = '';
        image = null;
      });
    });
    isLoading = false;
  }

  Future<void> pickImage(ImageSource source) async {
    final instance = ImagePicker();

    final xFile = await instance.pickImage(source: source);
    if (xFile == null) {
      return;
    }

    final img = File(xFile.path);

    setState(() {
      image = img;
    });
  }

  //?################################## end method / functions ###########################################

  @override
  Widget build(BuildContext context) {
    chatMethods = Provider.of<ChatMethods>(context, listen: false);
    authMethods = Provider.of<AuthMethods>(context, listen: false);
    return Scaffold(
      backgroundColor: AppColors.toggleScreenLIght(),
      appBar: AppBar(
        backgroundColor: AppColors.toggleScreenLIght(),
        titleSpacing: -10,
        title: Row(
          children: [
            CircleAvatar(
              backgroundColor: Colors.orange,
              backgroundImage: NetworkImage(widget.userModel!.profileImage!),
            ),
            const SizedBox(
              width: 10.0,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.userModel!.name!,
                  style: TextStyle(
                    color: AppColors.textDefultColor(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  'active now',
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.call,
              color: AppColors.iconColor(),
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.info_outlined,
              color: AppColors.iconColor(),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream: chatMethods!.fetchMessage(
                  currentUserId: authMethods!.currentUser().uid,
                  reciverId: widget.userModel!.id!),
              builder: (context, messageData) {
                if (messageData.hasData) {
                  final data = messageData.data;
                  return ListView.builder(
                    reverse: true,
                    itemCount: data!.docs.isEmpty ? 0 : data.docs.length,
                    itemBuilder: (context, index) {
                      ChatModel chatModel = ChatModel.formMap(
                          data.docs[index].data() as Map<String, dynamic>);
                      return ChatBubble(
                          chatModel, authMethods!.currentUser().uid);
                    },
                  );
                }
                return const Text(
                  'Loading...',
                  style: TextStyle(
                    color: Colors.grey,
                    fontWeight: FontWeight.bold,
                  ),
                );
              },
            ),
          ),
          if (image != null && isLoading == false)
            Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.35,
              ),
              child: Image.file(image!),
            ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: Row(
              children: [
                IconButton(
                  onPressed: () {
                    pickImage(ImageSource.camera);
                  },
                  icon: Icon(
                    Icons.camera_alt,
                    color: AppColors.iconColor(),
                  ),
                ),
                Flexible(
                  child: TextField(
                    controller: textEditorController,
                    onChanged: (value) {
                      setState(() {
                        messageText = value;
                      });
                    },
                    style: TextStyle(
                      color: AppColors.textDefultColor(),
                    ),
                    cursorColor: AppColors.textDefultColor(),
                    decoration: InputDecoration(
                      hintText: 'type something',
                      hintStyle: const TextStyle(color: Colors.grey),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          50.0,
                        ),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(
                          50.0,
                        ),
                      ),
                      isDense: true,
                      filled: true,
                      fillColor: const Color.fromARGB(183, 39, 39, 39),
                      border: InputBorder.none,
                    ),
                  ),
                ),
                FloatingActionButton(
                  onPressed: (messageText.isEmpty && image == null)
                      ? null
                      : () {
                          sendMessageToDb();
                        },
                  backgroundColor: (messageText.isEmpty && image == null)
                      ? AppColors.defautlColor.withOpacity(
                          0.3,
                        )
                      : AppColors.defautlColor,
                  child: Icon(
                    (messageText.isEmpty && image == null)
                        ? Icons.cancel_schedule_send_sharp
                        : Icons.send,
                    color: (messageText.isEmpty && image == null)
                        ? AppColors.iconColor().withOpacity(0.5)
                        : AppColors.iconColor(),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
