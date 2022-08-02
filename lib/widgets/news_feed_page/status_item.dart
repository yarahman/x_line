import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../themes/app_colors.dart';
import '../../models/status_model.dart';
import '../../providers/home_methods.dart';
import '../../models/user_model.dart';
import './../../providers/auth_methods.dart';
import '../custom/custom_page_route.dart';
import '../../screens/comment_screen.dart';

class StatusItem extends StatefulWidget {
  StatusItem({this.statusModel});
  StatusModel? statusModel;

  @override
  State<StatusItem> createState() => _StatusItemState();
}

class _StatusItemState extends State<StatusItem> {
  HomeMethods? homeMethods;
  AuthMethods? authMethods;
  var numOfLike = 0;
  var comment = '';
  var isFetingDataNow = false;
  var isLiked;

  Future<void> updateLikeIcon() async {}

  @override
  Widget build(BuildContext context) {
    homeMethods = Provider.of<HomeMethods>(context, listen: false);
    authMethods = Provider.of<AuthMethods>(context, listen: false);
    return StreamBuilder<DocumentSnapshot>(
      stream: homeMethods!.fetchUserDetails(widget.statusModel!.userId!),
      builder: (context, snapShot) {
        if (snapShot.hasData) {
          final model =
              UserModel.formMap(snapShot.data!.data() as Map<String, dynamic>);

          UserModel userModel = model;
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 5.0),
            child: Card(
              color: AppColors.widgetColor,
              elevation: 2.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey,
                            backgroundImage:
                                NetworkImage(userModel.profileImage!),
                          ),
                          const SizedBox(
                            width: 10.0,
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                userModel.name!,
                                style: TextStyle(
                                    color: AppColors.textDefultColor(),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 18.0),
                              ),
                              const Text(
                                'time ago',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.close,
                          color: AppColors.iconColor(),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(
                      vertical:
                          widget.statusModel!.imageUrl == null ? 40.0 : 1.0,
                    ),
                    child: Text(
                      widget.statusModel!.status == null
                          ? ''
                          : widget.statusModel!.status!,
                      style: TextStyle(
                        color: AppColors.textDefultColor(),
                      ),
                    ),
                  ),
                  Container(
                    child: widget.statusModel!.imageUrl == null
                        ? Container()
                        : CachedNetworkImage(
                            imageUrl: widget.statusModel!.imageUrl!,
                            fit: BoxFit.cover,
                            progressIndicatorBuilder: (context, url, progress) {
                              return Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Center(
                                  child: CircularProgressIndicator(
                                    color: AppColors.defautlColor,
                                    value: progress.progress,
                                  ),
                                ),
                              );
                            },
                          ),
                  ),
                  const SizedBox(
                    height: 5.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text(
                            widget.statusModel!.likeCount.toString(),
                            style: TextStyle(
                              color: AppColors.textDefultColor(),
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.thumb_up_alt_outlined,
                              color: AppColors.iconColor(),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            widget.statusModel!.commentNumber.toString(),
                            style:
                                TextStyle(color: AppColors.textDefultColor()),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.of(context)
                                  .push(
                                CustomPageRoute(
                                  child: CommentScreen(widget.statusModel),
                                ),
                              )
                                  .then((value) {
                                homeMethods!.updateCommentNumber(
                                    docId: widget.statusModel!.id!,
                                    commentNum: value);
                              });
                            },
                            icon: Icon(
                              Icons.comment_outlined,
                              color: AppColors.iconColor(),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text(
                            '0',
                            style: TextStyle(
                              color: AppColors.textDefultColor(),
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: Icon(
                              Icons.share,
                              color: AppColors.iconColor(),
                            ),
                          ),
                        ],
                      ),
                    ],
                  )
                ],
              ),
            ),
          );
        }
        return Container();
      },
    );
  }
}
