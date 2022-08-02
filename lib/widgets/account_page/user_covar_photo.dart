import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../../screens/image_view_screen.dart';
import '../../themes/app_colors.dart';

class UserCovarPhoto extends StatelessWidget {
  UserCovarPhoto(this.covarPicUrl);
  final String covarPicUrl;

  var tag = 'covar';

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => ImageViewScreen(
              imageUrl: covarPicUrl,
              tag: tag,
            ),
          ),
        );
      },
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.3,
        width: double.infinity,
        child: Hero(
          tag: tag,
          child: CachedNetworkImage(
            imageUrl: covarPicUrl,
            fit: BoxFit.cover,
            progressIndicatorBuilder: (context, string, downloadProgress) {
              return Center(
                child: CircularProgressIndicator(
                  color: AppColors.defautlColor,
                  value: downloadProgress.progress,
                ),
              );
            },
            errorWidget: (context, string, some) {
              return Row(
                children: [
                  const Icon(
                    Icons.error,
                    color: Colors.red,
                  ),
                  Text(
                    'an error occared',
                    style: TextStyle(
                      color: AppColors.textDefultColor(),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
