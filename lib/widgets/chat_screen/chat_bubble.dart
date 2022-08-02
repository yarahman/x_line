import 'package:flutter/material.dart';

import '../../themes/app_colors.dart';
import '../../models/chat_model.dart';

class ChatBubble extends StatelessWidget {
  ChatBubble(this.chatModel, this.currentUserId);
  ChatModel? chatModel;
  String? currentUserId;

  @override
  Widget build(BuildContext context) {
    return chatModel!.type == 'text'
        ? Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Row(
              mainAxisAlignment: chatModel!.senderId == currentUserId
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                Container(
                  constraints: BoxConstraints(
                      maxWidth: MediaQuery.of(context).size.width * 0.7),
                  decoration: BoxDecoration(
                    color: chatModel!.senderId == currentUserId
                        ? AppColors.defautlColor.withOpacity(0.8)
                        : Colors.grey.withOpacity(0.5),
                    borderRadius: chatModel!.senderId == currentUserId
                        ? const BorderRadius.only(
                            bottomLeft: Radius.circular(
                              50.0,
                            ),
                            topLeft: Radius.circular(
                              50.0,
                            ),
                            topRight: Radius.circular(
                              50.0,
                            ),
                          )
                        : const BorderRadius.only(
                            bottomRight: Radius.circular(50.0),
                            topLeft: Radius.circular(50.0),
                            topRight: Radius.circular(50.0),
                          ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Text(
                      chatModel!.message!,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: AppColors.textDefultColor(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          )

//* ####################################### bottom is for image ##########################################
        : Padding(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Row(
              mainAxisAlignment: chatModel!.senderId == currentUserId
                  ? MainAxisAlignment.end
                  : MainAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: chatModel!.senderId == currentUserId
                      ? CrossAxisAlignment.end
                      : CrossAxisAlignment.start,
                  children: [
                    Container(
                      constraints: const BoxConstraints(
                          maxHeight: 400.0, maxWidth: 250.0),
                      child: ClipRRect(
                        borderRadius: chatModel!.message!.isNotEmpty
                            ? chatModel!.senderId == currentUserId
                                ? const BorderRadius.only(
                                    topLeft: Radius.circular(
                                      10.0,
                                    ),
                                    topRight: Radius.circular(10.0),
                                    bottomLeft: Radius.circular(10.0),
                                  )
                                : const BorderRadius.only(
                                    topLeft: Radius.circular(
                                      10.0,
                                    ),
                                    topRight: Radius.circular(10.0),
                                    bottomRight: Radius.circular(10.0),
                                  )
                            : BorderRadius.circular(
                                10.0,
                              ),
                        child: Image.network(
                          chatModel!.imageUrl!,
                        ),
                      ),
                    ),
                    if (chatModel!.message!.isNotEmpty)
                      Container(
                        constraints: const BoxConstraints(maxWidth: 250.0),
                        decoration: BoxDecoration(
                          color: chatModel!.senderId == currentUserId
                              ? AppColors.defautlColor.withOpacity(0.8)
                              : Colors.grey.withOpacity(0.5),
                          borderRadius: const BorderRadius.only(
                            bottomLeft: Radius.circular(
                              50.0,
                            ),
                            bottomRight: Radius.circular(
                              50.0,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(10.0),
                          child: Text(
                            chatModel!.message!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.textDefultColor(),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          );
  }
}
