import 'package:flutter/material.dart';

import '../../themes/app_colors.dart';

class LogInButton extends StatelessWidget {
  LogInButton({required this.ontap, required this.text});

  VoidCallback? ontap;
  String? text;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      borderRadius: BorderRadius.circular(50.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            50.0,
          ),
        ),
        shadowColor: const Color.fromARGB(255, 95, 95, 95),
        elevation: 5.0,
        child: Container(
          height: 50.0,
          width: MediaQuery.of(context).size.width * 0.4,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(
              0xffF26351,
            ),
            borderRadius: BorderRadius.circular(
              50,
            ),
          ),
          child: Text(
            text!,
            style: TextStyle(
                fontSize: 20.0,
                color: AppColors.textDefultColor(),
                fontWeight: FontWeight.bold),
          ),
        ),
      ),
    );
  }
}
