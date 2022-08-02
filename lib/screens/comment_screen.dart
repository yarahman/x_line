import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../themes/app_colors.dart';
import '../widgets/news_feed_page/comment_item.dart';
import '../providers/home_methods.dart';
import '../providers/auth_methods.dart';
import '../models/status_model.dart';
import '../models/comment_model.dart';

class CommentScreen extends StatefulWidget {
  CommentScreen(
    this.statusModel,
  );

  StatusModel? statusModel;

  @override
  State<CommentScreen> createState() => _CommentScreenState();
}

class _CommentScreenState extends State<CommentScreen> {
  //*------------------------------------------ global variables -----------------------------------------------------
  var comment = '';
  File? image;
  HomeMethods? homeMethods;
  AuthMethods? authMethods;
  var isLoading = false;
  final controller = TextEditingController();
  int commentNumber = 0;

//?$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ end global variabls $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$

//* -------------------------------------------- methods / functions ----------------------------------------------

  Future<void> pickImage(ImageSource source) async {
    final instance = ImagePicker();

    final xFile = await instance.pickImage(source: source);

    if (xFile != null) {
      final img = File(xFile.path);

      setState(() {
        image = img;
      });
    }
  }

  Future<void> uploadCommentToDb() async {
    setState(() {
      isLoading = true;
      controller.clear();
    });

    await homeMethods!.sendCommentToDb(
        currentUserId: authMethods!.currentUser().uid,
        docId: widget.statusModel!.id!,
        comment: comment,
        image: image);

    setState(() {
      comment = '';
      image = null;
      isLoading = false;
    });
  }

//?$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$$ end methods / functions $$$$$$$$$$$$$$$$$$$$$$$$$$$$$$
  @override
  Widget build(BuildContext context) {
    homeMethods = Provider.of<HomeMethods>(context, listen: false);
    authMethods = Provider.of<AuthMethods>(context, listen: false);
    return Scaffold(
      backgroundColor: AppColors.toggleScreenLIght(),
      body: Padding(
        padding: const EdgeInsets.only(top: 40.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                IconButton(
                  onPressed: () {
                    Navigator.of(context).pop(commentNumber);
                  },
                  icon: Icon(
                    Icons.close,
                    color: AppColors.iconColor(),
                  ),
                ),
                Text(
                  'comments',
                  style: TextStyle(
                    fontSize: 20.0,
                    color: AppColors.textDefultColor(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Expanded(
              child: StreamBuilder<QuerySnapshot>(
                stream: homeMethods!.fetchingComment(
                  docId: widget.statusModel!.id!,
                ),
                builder: (context, snapData) {
                  if (snapData.hasData) {
                    commentNumber = snapData.data!.docs.length;
                    return ListView.builder(
                      reverse: true,
                      padding: const EdgeInsets.only(
                          left: 10.0, right: 10.0, top: 20.0),
                      itemCount: snapData.data!.docs.isEmpty
                          ? 0
                          : commentNumber,
                      itemBuilder: (context, index) {
                        CommentModel commentModel = CommentModel.formMap(
                            snapData.data!.docs[index].data()
                                as Map<String, dynamic>);

                        return CommentItem(commentModel);
                      },
                    );
                  }
                  return const Center(
                    child: Text(
                      'no comment found for this post',
                      style: TextStyle(color: Colors.grey),
                    ),
                  );
                },
              ),
            ),
            if (image != null && isLoading == false)
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.3,
                child: Stack(
                  alignment: Alignment.topRight,
                  children: [
                    Center(
                      child: Image.file(
                        image!,
                      ),
                    ),
                    Positioned(
                      right: 13.0,
                      top: -2.0,
                      child: FloatingActionButton.small(
                        backgroundColor:
                            AppColors.defautlColor.withOpacity(0.7),
                        onPressed: () {
                          setState(() {
                            image = null;
                          });
                        },
                        child: Icon(
                          Icons.close,
                          color: AppColors.iconColor(),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            Row(
              children: [
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        pickImage(ImageSource.gallery);
                      },
                      icon: const Icon(
                        Icons.image,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        pickImage(ImageSource.camera);
                      },
                      icon: const Icon(
                        Icons.camera_alt,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: SizedBox(
                    height: 45.0,
                    child: TextField(
                      keyboardType: TextInputType.multiline,
                      controller: controller,
                      onChanged: (value) {
                        setState(() {
                          comment = value;
                        });
                      },
                      textAlignVertical: TextAlignVertical.bottom,
                      cursorColor: AppColors.defautlColor,
                      style: TextStyle(
                        color: AppColors.textDefultColor(),
                      ),
                      decoration: InputDecoration(
                        hintText: 'write a comment',
                        hintStyle: const TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                              color: AppColors.defautlColor, width: 1.0),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30.0),
                          borderSide: const BorderSide(
                              color: AppColors.defautlColor, width: 1.0),
                        ),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(bottom: 6.0),
                  child: IconButton(
                    onPressed: (comment.isEmpty && image == null)
                        ? null
                        : () {
                            uploadCommentToDb();
                          },
                    icon: isLoading
                        ? const CircularProgressIndicator(
                            color: AppColors.defautlColor,
                          )
                        : Icon(
                            Icons.send_outlined,
                            size: 37.0,
                            color: (comment.isEmpty && image == null)
                                ? AppColors.defautlColor.withOpacity(0.4)
                                : AppColors.defautlColor,
                          ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
