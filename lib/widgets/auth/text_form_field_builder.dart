import 'package:flutter/material.dart';

import '../../themes/app_colors.dart';

class TextFormFiledBuilder extends StatelessWidget {
  TextFormFiledBuilder(
      {this.hintText,
      this.borderRadius,
      this.borderSideColor,
      this.iconColor,
      this.showdowColor,
      this.suffixIcon,
      this.textColor,
      this.textFontSize,
      this.textFontWeight,
      this.hintTextColor,
      required this.onSaved,
      required this.validator});
  String? hintText;
  Color? hintTextColor;
  Color? showdowColor;
  double? borderRadius;
  Color? borderSideColor;
  Color? textColor;
  double? textFontSize;
  FontWeight? textFontWeight;
  IconData? suffixIcon;
  Color? iconColor;
  FormFieldValidator<String> validator;
  Function(String?) onSaved;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Card(
        color: AppColors.textFieldColor(),
        elevation: 5.0,
        shadowColor: showdowColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              borderRadius!,
            ),
            side: BorderSide(color: borderSideColor!, width: 0.5)),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: TextFormField(
            onSaved: onSaved,
            validator: validator,
            cursorColor: AppColors.textDefultColor(),
            style: TextStyle(
                color: textColor,
                fontSize: textFontSize,
                fontWeight: textFontWeight),
            decoration: InputDecoration(
              suffixIcon: Icon(
                suffixIcon,
                color: iconColor,
              ),
              hintText: hintText,
              hintStyle: TextStyle(
                color: hintTextColor,
              ),
              border: InputBorder.none,
            ),
          ),
        ),
      ),
    );
  }
}
