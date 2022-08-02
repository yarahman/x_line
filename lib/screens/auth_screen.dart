import 'package:flutter/material.dart';

import '../themes/app_colors.dart';
import '../widgets/auth/main_logo.dart';
import '../widgets/auth/user_input_field.dart';
import '../widgets/auth/bottom_text_button.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  @override
  Widget build(BuildContext context) {
    AppColors.statusbarColor;
    return Scaffold(
      backgroundColor: AppColors.toggleScreenLIght(),
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //*----------------------------------main logo and text -------------------------------------->

            const MainLogo(),

            //? =============== end main logo and text ==================================

            //* ------------------------------------ User Input Field --------------------------------------------->

            UserInputField(),

            //? ============================== end User Input Field ===========================

            //* -----------------------------------------Bottom account or not button ------------------------------------------

            const BottomTextButton(),

            //? =============================== end bottom acoount or not button ===============================
          ],
        ),
      ),
    );
  }
}
