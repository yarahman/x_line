import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:x_line/providers/home_methods.dart';

import '../../../themes/app_colors.dart';
import '../news_feed_page/status_item.dart';
import '../account_page/user_bio_text.dart';
import '../account_page/gender_text.dart';
import '../account_page/user_name.dart';
import '../account_page/user_profile_photo.dart';
import '../account_page/user_covar_photo.dart';
import '.././../providers/account_methods.dart';
import '../../providers/auth_methods.dart';
import '../../models/user_model.dart';
import '../../screens/edit_profile_screen.dart';
import '../../widgets/custom/custom_page_route.dart';
import '../../screens/create_post_screen.dart';
import '../../models/status_model.dart';

class AccountPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final currentUser = FirebaseAuth.instance.currentUser!.uid;
    final accountMethods = Provider.of<AccountMethods>(context, listen: false);
    final authMethod = Provider.of<AuthMethods>(context, listen: false);
    final homeMethods = Provider.of<HomeMethods>(context, listen: false);
    return FutureBuilder<UserModel>(
      future: accountMethods.fatchAccountDetails(currentUser),
      builder: (context, snapShot) {
        UserModel? userModel = snapShot.data;
        if (snapShot.hasData) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Stack(
                  alignment: Alignment.bottomLeft,
                  clipBehavior: Clip.none,
                  children: [
                    //* ------------------------------------- covar phtoto -----------------------------------------------------------------

                    UserCovarPhoto(userModel!.covarImage!),

                    //? ================================== end covar photo ===============================================

                    //*-------------------------------------------------- profile photo ------------------------------------------------------------------

                    UserProfilePhoto(userModel.profileImage!),

                    //?======================================== end profile photo ====================================================
                  ],
                ),

                //* --------------------------------------------------- name text here --------------------------------------------------------------------------------

                UserName(userModel.name!),

                //? ============================================ end name text =========================================================

                //* ------------------------------------------------------------gender text here --------------------------------------------------------------------

                GenderText(userModel.gender!),

                //?========================================== end gender text ======================================================

                //* ----------------------------------------------------------- bio text here -----------------------------------------------------------------------

                UserBioText(userModel.bio!),

                //?==============================================end bio text =======================================================

                const SizedBox(
                  height: 30.0,
                ),

                //* ----------------------------- list of buttons ----------------------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    //*------------------------------------------------------------------- create post button-------------------------------------------------------------------------
                    ElevatedButton.icon(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          AppColors.defautlColor,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context).push(
                          CustomPageRoute(
                            child: const CreatePostScreen(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.switch_account_sharp),
                      label: Text(
                        'create post',
                        style: TextStyle(
                          color: AppColors.textDefultColor(),
                        ),
                      ),
                    ),
                    //? ================================================== end create post botton ======================================================

                    //* ---------------------------------------------------- edit profile buttons -----------------------------------------------
                    ElevatedButton.icon(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.grey,
                        ),
                      ),
                      onPressed: () {
                        Navigator.of(context)
                            .push(
                              CustomPageRoute(
                                child: EditProfileScreen(userModel),
                              ),
                            )
                            .then((_) => {
                                  accountMethods
                                      .fatchAccountDetails(currentUser),
                                });
                      },
                      icon: const Icon(Icons.mode_edit_outlined),
                      label: Text(
                        'edit profile',
                        style: TextStyle(
                          color: AppColors.textDefultColor(),
                        ),
                      ),
                    ),

                    //?=================================== end edit profile buttons ============================================

                    //* ------------------------------------------ setting button -----------------------------------
                    ElevatedButton.icon(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(
                          Colors.grey,
                        ),
                      ),
                      onPressed: () {},
                      icon: const Icon(Icons.settings_suggest_outlined),
                      label: Text(
                        'setting',
                        style: TextStyle(
                          color: AppColors.textDefultColor(),
                        ),
                      ),
                    ),
                    //? =================================== end setting button ============================
                  ],
                ),
                //?=================== end list of buttons ===============================

                const SizedBox(
                  height: 30.0,
                ),

                //* ------------------------------------------------------------- post text ---------------------------------------------------------------------------
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: Card(
                    color: AppColors.widgetColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        10.0,
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        'Posts',
                        style: TextStyle(
                            color: AppColors.defautlColor,
                            fontSize: 20.0,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                ),

                //? =================================================== end post text =======================================================
                StreamBuilder<QuerySnapshot>(
                  stream: homeMethods.fatchAllPosts(),
                  builder: (context, snapShot) {
                    if (snapShot.hasData) {
                      final list = snapShot.data!.docs;
                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: list.isEmpty ? 0 : list.length,
                        itemBuilder: ((context, index) {
                          StatusModel statusModel = StatusModel.formMap(
                              list[index].data() as Map<String, dynamic>);
                          if (statusModel.userId ==
                              authMethod.currentUser().uid) {
                            return StatusItem(
                              statusModel: statusModel,
                            );
                          }
                          return Container();
                        }),
                      );
                    }
                    return const Align(
                      alignment: Alignment.center,
                      child: CircularProgressIndicator(
                        color: AppColors.defautlColor,
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        }
        return Container();
      },
    );
  }
}
