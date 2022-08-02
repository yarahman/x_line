import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../themes/app_colors.dart';
import '../providers/auth_methods.dart';
import '../widgets/custom/custom_page_route.dart';
import '../screens/home_screen.dart';

class AddingInfoScreen extends StatefulWidget {
  AddingInfoScreen({
    required this.name,
    required this.currentUserId,
  });

  var name = '';
  var currentUserId = '';

  @override
  State<AddingInfoScreen> createState() => _AddingInfoScreenState();
}

class _AddingInfoScreenState extends State<AddingInfoScreen> {
//* ----------------------------------- global variables ----------------------------------------->
  var bio = '';
  var gender = '';
  var isMale = false;
  var isFemale = false;
  File? covarImage;
  File? profileImage;
  var isCovarPic = false;
  var isProfilePic = false;
  late AuthMethods authMethods;
  var isLoading = false;
//?=================================== end global veriables ==============================

//* -------------------------------------------- methods / variables -------------------------------------->

//! this method reponsible for opening the
//! diolog for choosing camera or gallery
  void cameraOrGallerySelector(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => SimpleDialog(
        backgroundColor: AppColors.sndDefaultColor,
        title: const Text('choose one'),
        children: [
          Card(
            elevation: 5.0,
            child: TextButton.icon(
              onPressed: () {
                pickImage(ImageSource.camera).then((value) {
                  if (isProfilePic) {
                    setState(() {
                      profileImage = value;
                    });
                  } else if (isCovarPic) {
                    covarImage = value;
                  }
                });
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.camera,
                color: AppColors.defautlColor,
              ),
              label: const Text(
                'camera,',
                style: TextStyle(color: AppColors.defautlColor),
              ),
            ),
          ),
          Card(
            elevation: 5.0,
            child: TextButton.icon(
              onPressed: () {
                pickImage(ImageSource.gallery).then((value) {
                  if (isProfilePic) {
                    setState(() {
                      profileImage = value;
                    });
                  } else if (isCovarPic) {
                    setState(() {
                      covarImage = value;
                    });
                  }
                });
                Navigator.of(context).pop();
              },
              icon: const Icon(
                Icons.image_sharp,
                color: AppColors.defautlColor,
              ),
              label: const Text(
                'Gallery,',
                style: TextStyle(color: AppColors.defautlColor),
              ),
            ),
          ),
        ],
      ),
    );
  }

  //* end of diolog method//

  //! this method for pick image
  Future<File> pickImage(ImageSource source) async {
    final intance = ImagePicker();

    final xfileImage = await intance.pickImage(source: source);

    File imageFile = File(xfileImage!.path);

    return imageFile;
  }
  //* end of pick image method //

  Future<void> onSubmit() async {
    late String covarPhotoUrl;
    late String profilePhotoUrl;
    try {
      setState(() {
        isLoading = true;
      });
      await authMethods
          .uploadProfilePhotoToDb(profileImage!, widget.currentUserId)
          .then((covarPicUrl) {
        covarPhotoUrl = covarPicUrl;
      });

      await authMethods
          .uploadCovarPhotoToDb(covarImage!, widget.currentUserId)
          .then((profilePicUrl) {
        profilePhotoUrl = profilePicUrl;
      });

      await authMethods
          .addingUserToDb(
              id: widget.currentUserId,
              name: widget.name,
              bio: bio,
              covarPhoto: profilePhotoUrl,
              profilePhoto: covarPhotoUrl,
              gender: gender)
          .then((_) {
        Navigator.of(context).pushAndRemoveUntil(
            CustomPageRoute(child: const HomeScreen()), (route) => false);
      });
    } catch (e) {
      print(e);
      setState(() {
        isLoading = false;
      });
    }
  }

//?============================================ end methods / variables =========================

  @override
  Widget build(BuildContext context) {
    authMethods = Provider.of<AuthMethods>(context, listen: false);
    AppColors.statusbarColor;

    return Scaffold(
      backgroundColor: AppColors.toggleScreenLIght(),
      body: Column(
        mainAxisAlignment:
            isLoading ? MainAxisAlignment.center : MainAxisAlignment.start,
        children: [
          isLoading
              ? const Center(
                  child:
                      CircularProgressIndicator(color: AppColors.defautlColor),
                )
              : Expanded(
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Stack(
                          clipBehavior: Clip.none,
                          alignment: Alignment.bottomLeft,
                          children: [
                            //*--------------------------------------------------------- covar photo ---------------------------------------------
                            SizedBox(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height * 0.3,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(5.0),
                                child: covarImage == null
                                    ? Image.asset(
                                        'assets/images/default_covar_pic.png',
                                        fit: BoxFit.cover,
                                      )
                                    : Image.file(covarImage!),
                              ),
                            ),
                            Positioned(
                              left: MediaQuery.of(context).size.width * 0.88,
                              bottom: 5.0,
                              child: CircleAvatar(
                                backgroundColor: AppColors.defautlColor,
                                child: IconButton(
                                  onPressed: () {
                                    cameraOrGallerySelector(context);
                                    isCovarPic = true;
                                    isProfilePic = false;
                                  },
                                  icon: Icon(
                                    Icons.image,
                                    color: AppColors.iconColor(),
                                  ),
                                ),
                              ),
                            ),
                            //?============================================================= end covar photo =============================

                            //* ------------------------------------------------------------------ profile photo ----------------------------------------------------------------
                            Positioned(
                              top: MediaQuery.of(context).size.height * 0.23,
                              child: GestureDetector(
                                onTap: () {
                                  cameraOrGallerySelector(context);
                                  isProfilePic = true;
                                  isCovarPic = false;
                                },
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    profileImage == null
                                        ? const CircleAvatar(
                                            radius: 50.0,
                                            backgroundImage: AssetImage(
                                                'assets/images/def_pro_pic.png'),
                                          )
                                        : CircleAvatar(
                                            radius: 50.0,
                                            backgroundImage: FileImage(
                                              profileImage!,
                                            ),
                                          ),
                                    if (profileImage == null)
                                      Icon(
                                        Icons.camera_enhance,
                                        size: 30,
                                        color: AppColors.iconColor(),
                                      ),
                                  ],
                                ),
                              ),
                            ),

                            //? ================================================= end profile photo ===============================================

                            Positioned(
                              bottom: 170,
                              child: IconButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                                icon: const Icon(
                                  Icons.arrow_back_rounded,
                                  color: AppColors.defautlColor,
                                ),
                              ),
                            ),

                            //* ------------------------------------------------------------------- user name -------------------------------------------------------->
                          ],
                        ),
                        const SizedBox(
                          height: 50.0,
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          margin: const EdgeInsets.only(left: 8.0),
                          child: Text(
                            widget.name,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 25.0,
                              color: AppColors.textDefultColor(),
                            ),
                          ),
                        ),

                        //? ==================================================== end user name ================================================

                        //* ------------------------------------------------- user bio data / Text Field --------------------------------------------------------------------------->
                        const SizedBox(
                          height: 20.0,
                        ),
                        Card(
                          shadowColor: AppColors.textFieldShadowColor,
                          color: AppColors.textFieldColor(),
                          elevation: 5.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              20.0,
                            ),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(5.0),
                            child: TextField(
                              style: TextStyle(
                                color: AppColors.textDefultColor(),
                                fontWeight: FontWeight.bold,
                              ),
                              cursorColor: AppColors.textDefultColor(),
                              onChanged: (value) {
                                setState(() {
                                  bio = value;
                                });
                              },
                              maxLength: 200,
                              maxLines: 5,
                              decoration: const InputDecoration(
                                hintText: 'Please Describe Yourself',
                                hintStyle: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey),
                                border: InputBorder.none,
                              ),
                            ),
                          ),
                        ),

                        //? ==================================== end user bio data / Text Field ==================================================================

                        //* ------------------------------------- gender selector buttons ---------------------------------------->
                        const SizedBox(
                          height: 30.0,
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(horizontal: 10.0),
                          alignment: Alignment.centerLeft,
                          child: const Text(
                            'select you gender',
                            style: TextStyle(
                              fontSize: 14.0,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            genderButton(
                              () {
                                gender = 'Male';
                                setState(() {
                                  isMale = true;
                                  isFemale = false;
                                });
                              },
                              'Male',
                              Icons.male,
                              isMale
                                  ? AppColors.defautlColor
                                  : AppColors.textDefultColor(),
                            ),
                            genderButton(
                              () {
                                gender = 'Femlae';
                                setState(() {
                                  isFemale = true;
                                  isMale = false;
                                });
                              },
                              'Female',
                              Icons.female,
                              isFemale
                                  ? AppColors.defautlColor
                                  : AppColors.textDefultColor(),
                            ),
                          ],
                        ),
                        //? ================================================== gender selector end ====================================
                      ],
                    ),
                  ),
                ),
          //* --------------------------------------------------------- bottom Goo Button ------------------------------------------------->
          isLoading
              ? Container()
              : InkWell(
                  borderRadius: BorderRadius.circular(10.0),
                  highlightColor: Colors.white,
                  onTap: onSubmit,
                  child: Container(
                    height: 50.0,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: AppColors.defautlColor,
                      borderRadius: BorderRadius.circular(
                        10,
                      ),
                    ),
                    child: Center(
                      child: Text(
                        'Goo',
                        style: TextStyle(
                          color: AppColors.textDefultColor(),
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),

          //? =============================================== end bottom go button ===================================
        ],
      ),
    );
  }

  //* ---------------------------- widgets methods ----------------------------------------------------------------
  Widget genderButton(
      VoidCallback onTap, String title, IconData icon, Color textOrIconColor) {
    return Card(
      color: Colors.white.withOpacity(0.0),
      elevation: 5.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          50.0,
        ),
      ),
      child: Container(
        height: 40.0,
        width: 130.0,
        decoration: BoxDecoration(
          border: Border.all(
            color: AppColors.iconColor(),
          ),
          borderRadius: BorderRadius.circular(
            50.0,
          ),
        ),
        child: TextButton.icon(
          onPressed: onTap,
          icon: Icon(
            icon,
            size: 30.0,
            color: textOrIconColor,
          ),
          label: Text(
            title,
            style: TextStyle(color: textOrIconColor, fontSize: 20.0),
          ),
        ),
      ),
    );
  }
}
