import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../themes/app_colors.dart';
import './text_form_field_builder.dart';
import './log_in_button.dart';
import '../custom/custom_page_route.dart';
import '../../screens/adding_info_screen.dart';
import '../../providers/auth_methods.dart';

class SignUpFiled extends StatefulWidget {
  const SignUpFiled({Key? key}) : super(key: key);

  @override
  State<SignUpFiled> createState() => _SignUpFiledState();
}

class _SignUpFiledState extends State<SignUpFiled> {
  //* ---------------------------------------------------> global Variables <--------------------------------------

  final GlobalKey<FormState> _signUpKey = GlobalKey();
  var firstName = '';
  var lastName = '';
  var email = '';
  var password = '';
  late AuthMethods authMethods;
  var isLoading = false;

  //?======================================= end global variables ==========================

  //* ------------------------ my Functions / Methods -------------------------------------------------------

//? this method resposible to store user in firebase
//! not firestore clould, just resgister user
  void saveInutFieldData() async {
    try {
      if (!_signUpKey.currentState!.validate()) {
        return;
      }
      setState(() {
        isLoading = true;
      });
      _signUpKey.currentState!.save();

      await authMethods.singUpUser(email, password).then((user) {
        Navigator.of(context).push(
          CustomPageRoute(
            child: AddingInfoScreen(
              name: '$firstName $lastName',
              currentUserId: user.uid,
            ),
          ),
        );
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

  //? =============================== end my funtcion / mehtods ========================
  @override
  Widget build(BuildContext context) {
    authMethods = Provider.of<AuthMethods>(context, listen: false);
    return Container(
      color: AppColors.toggleScreenLIght(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          //* ------------------------------- sing up text ----------------------------------------------------------
          const Align(
            alignment: Alignment.topLeft,
            child: Padding(
              padding: EdgeInsets.only(top: 40.0),
              child: Text(
                'Sign Up',
                style: TextStyle(
                    color: AppColors.defautlColor,
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
          ),
          //? ======================================== end sign up text ==============================

          //* ------------------------------------------------------------- input fields -------------------------------------------
          isLoading
              ? const Center(
                  child:
                      CircularProgressIndicator(color: AppColors.defautlColor),
                )
              : Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Form(
                      key: _signUpKey,
                      child: Column(
                        children: [
                          TextFormFiledBuilder(
                            onSaved: (val) {
                              setState(() {
                                firstName = val!;
                              });
                            },
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'please enter valid name';
                              }
                              return null;
                            },
                            hintText: 'enter your first name',
                            hintTextColor: const Color.fromARGB(
                              255,
                              202,
                              202,
                              202,
                            ),
                            borderRadius: 50.0,
                            borderSideColor:
                                const Color.fromARGB(255, 204, 204, 204),
                            showdowColor: const Color.fromARGB(255, 95, 95, 95),
                            suffixIcon: Icons.abc,
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
                                lastName = val!;
                              });
                            },
                            validator: (val) {
                              if (val!.isEmpty) {
                                return 'please enter valid name';
                              }
                              return null;
                            },
                            hintText: 'enter your last name',
                            hintTextColor: const Color.fromARGB(
                              255,
                              202,
                              202,
                              202,
                            ),
                            borderRadius: 50.0,
                            borderSideColor:
                                const Color.fromARGB(255, 204, 204, 204),
                            showdowColor: const Color.fromARGB(255, 95, 95, 95),
                            suffixIcon: Icons.abc,
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
                                email = val!;
                              });
                            },
                            validator: (val) {
                              if (val!.isEmpty ||
                                  !val.contains('@') ||
                                  !val.endsWith('.com')) {
                                return 'please enter a valid email';
                              }
                              return null;
                            },
                            hintText: 'enter emeail or phone',
                            hintTextColor: const Color.fromARGB(
                              255,
                              202,
                              202,
                              202,
                            ),
                            borderRadius: 50.0,
                            borderSideColor:
                                const Color.fromARGB(255, 204, 204, 204),
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
                              if (val!.isEmpty) {
                                return 'please enter a password';
                              } else if (val.length < 6) {
                                return 'please enter 6 or more charaters password';
                              }
                              return null;
                            },
                            hintText: 'enter a password',
                            hintTextColor: const Color.fromARGB(
                              255,
                              202,
                              202,
                              202,
                            ),
                            borderRadius: 50.0,
                            borderSideColor:
                                const Color.fromARGB(255, 204, 204, 204),
                            showdowColor: const Color.fromARGB(255, 95, 95, 95),
                            suffixIcon: Icons.abc,
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
                        ],
                      ),
                    ),
                  ),
                ),
          //? ================================================ end inputs field ======================================

          //* -------------------------------------------------------------- next button ------------------------------------------------------------->
          isLoading
              ? Container()
              : LogInButton(ontap: saveInutFieldData, text: 'Next'),

          //? =================================================end next button =========================================
        ],
      ),
    );
  }
}
