import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:x_line/screens/home_screen.dart';
import 'package:x_line/widgets/custom/custom_page_route.dart';

import './text_form_field_builder.dart';
import './log_in_button.dart';
import '../../themes/app_colors.dart';
import '../../providers/auth_methods.dart';

class UserInputField extends StatefulWidget {
  const UserInputField({
    Key? key,
  }) : super(key: key);

  @override
  State<UserInputField> createState() => _UserInputFieldState();
}

class _UserInputFieldState extends State<UserInputField> {
  final GlobalKey<FormState> logInKey = GlobalKey();
  AuthMethods? authMethods;
  var email = '';
  var password = '';
  var isLoading = false;

  void logInUser() {
    if (!logInKey.currentState!.validate()) {
      return;
    }
    logInKey.currentState!.save();
    setState(() {
      isLoading = true;
    });
    authMethods!.logInUser(email, password).then((value) {
      Navigator.of(context).pushAndRemoveUntil(
          CustomPageRoute(child: const HomeScreen()), (route) => false);
    });

    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    authMethods = Provider.of<AuthMethods>(context, listen: false);
    return Expanded(
      flex: 7,
      child: Form(
        key: logInKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormFiledBuilder(
              onSaved: (val) {
                setState(() {
                  email = val!;
                });
              },
              validator: (val) {
                return null;
              },
              hintText: 'email or phone',
              hintTextColor: const Color.fromARGB(
                255,
                202,
                202,
                202,
              ),
              borderRadius: 50.0,
              borderSideColor: const Color.fromARGB(255, 204, 204, 204),
              showdowColor: const Color.fromARGB(255, 95, 95, 95),
              suffixIcon: Icons.email,
              iconColor: const Color.fromARGB(
                255,
                202,
                202,
                202,
              ),
              textFontSize: 18.0,
              textColor: AppColors.textDefultColor(),
              textFontWeight: FontWeight.bold,
            ),
            TextFormFiledBuilder(
              onSaved: (val) {
                setState(() {
                  password = val!;
                });
              },
              validator: (val) {
                return null;
              },
              hintText: 'password',
              hintTextColor: const Color.fromARGB(
                255,
                202,
                202,
                202,
              ),
              borderRadius: 50.0,
              borderSideColor: const Color.fromARGB(255, 204, 204, 204),
              showdowColor: const Color.fromARGB(255, 95, 95, 95),
              suffixIcon: Icons.password,
              iconColor: const Color.fromARGB(
                255,
                202,
                202,
                202,
              ),
              textFontSize: 18.0,
              textColor: AppColors.textDefultColor(),
              textFontWeight: FontWeight.bold,
            ),
            LogInButton(
              ontap: () {
                logInUser();
              },
              text: isLoading ? 'Loading' : 'Goo',
            ),
          ],
        ),
      ),
    );
  }
}
