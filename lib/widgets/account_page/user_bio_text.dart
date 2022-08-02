import 'package:flutter/material.dart';

import '../../themes/app_colors.dart';

class UserBioText extends StatelessWidget {
  const UserBioText(this.userBioData);
  final String userBioData;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 50.0),
        child: Text(
          userBioData,
          style:
               TextStyle(fontWeight: FontWeight.bold, color: AppColors.textDefultColor(),),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
