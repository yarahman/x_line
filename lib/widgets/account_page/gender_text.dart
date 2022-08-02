import 'package:flutter/material.dart';

import '../../themes/app_colors.dart';

class GenderText extends StatelessWidget {
  const GenderText(this.genderText);
  final String genderText;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
          left: MediaQuery.of(context).size.width * 0.14, top: 5.0),
      child: Text(
        genderText,
        style: const TextStyle(color: AppColors.defautlColor),
      ),
    );
  }
}
