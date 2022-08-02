import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import '../themes/app_colors.dart';

class ImageViewScreen extends StatelessWidget {
  const ImageViewScreen({this.imageUrl, this.tag});
  final String? imageUrl;
  final String? tag;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.toggleScreenLIght(),
      appBar: AppBar(
        backgroundColor: AppColors.toggleScreenLIght(),
      ),
      body: Hero(
        tag: tag!,
        child: Center(
          child: CachedNetworkImage(
            imageUrl: imageUrl!,
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
                crossAxisAlignment: CrossAxisAlignment.center,
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
