import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../../themes/app_colors.dart';
import '../../screens/image_view_screen.dart';

class UserProfilePhoto extends StatelessWidget {
  UserProfilePhoto(this.profilePicUrl);
  final String profilePicUrl;

  var tag = 'profile';

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: MediaQuery.of(context).size.height * 0.23,
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) =>
                  ImageViewScreen(imageUrl: profilePicUrl, tag: tag),
            ),
          );
        },
        child: Stack(
          alignment: Alignment.bottomRight,
          clipBehavior: Clip.none,
          children: [
            CircleAvatar(
              radius: 54.0,
              backgroundColor: AppColors.toggleScreenLIght(),
              child: Hero(
                tag: tag,
                child: Container(
                  clipBehavior: Clip.antiAliasWithSaveLayer,
                  height: 100.0,
                  width: 100.0,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      50.0,
                    ),
                  ),
                  child: CachedNetworkImage(
                    imageUrl: profilePicUrl,
                    fit: BoxFit.cover,
                    progressIndicatorBuilder:
                        (context, string, downloadProgress) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: AppColors.defautlColor,
                          value: downloadProgress.progress,
                        ),
                      );
                    },
                    errorWidget: (context, string, some) {
                      return Center(
                        child: Icon(
                          Icons.error,
                          color: AppColors.iconColor(),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 7.0,
              right: 10.0,
              child: Container(
                width: 18.0,
                height: 18.0,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      50.0,
                    ),
                    color: Colors.green),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
