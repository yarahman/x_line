import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:x_line/themes/app_colors.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../models/comment_model.dart';
import '../../models/user_model.dart';
import '../../providers/home_methods.dart';

class CommentItem extends StatelessWidget {
  CommentItem(this.commentModel);
  CommentModel? commentModel;

  HomeMethods? homeMethods;
  UserModel? userModel;
  @override
  Widget build(BuildContext context) {
    homeMethods = Provider.of<HomeMethods>(context, listen: false);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 5.0),
      padding: const EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20.0),
        color: Colors.grey.withOpacity(0.35),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              StreamBuilder<DocumentSnapshot>(
                stream: homeMethods!.fetchUserDetails(commentModel!.userId!),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    userModel = UserModel.formMap(
                        snapshot.data!.data() as Map<String, dynamic>);
                    return Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.grey,
                          backgroundImage:
                              NetworkImage(userModel!.profileImage!),
                        ),
                        const SizedBox(
                          width: 10.0,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 5.0),
                              child: Text(
                                userModel!.name!,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20.0),
                              ),
                            ),
                            const SizedBox(
                              height: 7.0,
                            ),
                            Text(
                              commentModel!.comment!,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ],
                        ),
                      ],
                    );
                  }
                  return Container();
                },
              ),
              Text(
                '5h ago',
                style: TextStyle(
                  color: AppColors.textDefultColor(),
                ),
              ),
            ],
          ),
          if (commentModel!.imageUrl != null)
            const SizedBox(
              height: 7.0,
            ),
          if (commentModel!.imageUrl != null)
          CachedNetworkImage(
            imageUrl: commentModel!.imageUrl!,
            progressIndicatorBuilder: (context, url, progress) {
              return Center(
                child: CircularProgressIndicator(
                  value: progress.progress,
                  color: AppColors.defautlColor,
                ),
              );
            },
            errorWidget: (context, url, error) {
              return const Text(
                'image loading failed',
                style: TextStyle(color: Colors.grey),
              );
            },
          ),
        ],
      ),
    );
  }
}
