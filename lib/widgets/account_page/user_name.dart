import 'package:flutter/material.dart';

import '../../themes/app_colors.dart';

class UserName extends StatelessWidget {
  const UserName(this.name);
  final String name;

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.only(
            top: 70.0, left: MediaQuery.of(context).size.width * 0.03),
        child: name.isNotEmpty
            ? Text(
                name,
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDefultColor(),
                ),
              )
            : const CircularProgressIndicator(
                color: AppColors.defautlColor,
              ));
  }
}
