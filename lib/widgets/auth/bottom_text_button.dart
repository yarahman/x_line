import 'package:flutter/material.dart';

import '../../themes/app_colors.dart';
import './sign_up_field.dart';

class BottomTextButton extends StatelessWidget {
  const BottomTextButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Flexible(
      child: Container(
        alignment: Alignment.center,
        height: 40.0,
        width: double.infinity,
        color: AppColors.defautlColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'do not have a account?',
              style: TextStyle(
                color: AppColors.textDefultColor(),
              ),
            ),
            TextButton(
              onPressed: () {
                showModalBottomSheet(
                  isScrollControlled: true,
                  context: context,
                  builder: (BuildContext context) {
                    return const SignUpFiled();
                  },
                );
              },
              child: const Text(
                'Sign Up Now',
                style: TextStyle(
                  color: AppColors.sndDefaultColor,
                  fontSize: 15.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
