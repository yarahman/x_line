import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:x_line/models/user_model.dart';

import '../themes/app_colors.dart';
import '../providers/account_methods.dart';
import '../providers/auth_methods.dart';

class EditProfileScreen extends StatefulWidget {
  EditProfileScreen(this.userModel);
  UserModel? userModel;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
//* -------------------------- global variables -------------------------------
  File? profilePic;
  File? covarPic;
  File? nullImage;
  String? name = '';
  String? gender = '';
  String? bio = '';
  var isProfilePic = false;
  var isCovarPic = false;
  late AccountMethods accountMethods;
  late AuthMethods authMethods;
  var isLoading = false;

//* -------------------------------- methods / functions --------------------------------

  Future<File> pickImage(ImageSource source) async {
    File? image;
    final imageInstanec = ImagePicker();
    var pickedImage = await imageInstanec.pickImage(source: source);

    if (pickedImage != null) {
      image = File(pickedImage.path);
    }

    if (isProfilePic) {
      setState(() {
        profilePic = image;
      });
      if (profilePic != null) {
        return profilePic!;
      }
    } else if (isCovarPic) {
      setState(() {
        covarPic = image;
      });
      if (covarPic != null) {
        return covarPic!;
      }
    }
    return nullImage!;
  }

  @override
  Widget build(BuildContext context) {
    accountMethods = Provider.of<AccountMethods>(context, listen: false);
    authMethods = Provider.of<AuthMethods>(context, listen: false);
    return Scaffold(
      backgroundColor: AppColors.toggleScreenLIght(),

//* ----------------------------------------- app bar -------------------------------------------------------
      appBar: AppBar(
        backgroundColor: AppColors.toggleScreenLIght(),
        title: Text(
          'edit profile',
          style: TextStyle(
            color: AppColors.textDefultColor(),
          ),
        ),
      ),

//? =============================== end app bar ========================================
      body: SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.bottomLeft,
              clipBehavior: Clip.none,
              children: [
                //* ----------------------------------------- covar photo ------------------------------------------------------------
                GestureDetector(
                  onTap: () {
                    isCovarPic = true;
                    showModalBottomSheet(
                            context: context,
                            builder: (context) => chooseImageOpntions())
                        .then((_) {});
                  },
                  child: Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: double.infinity,
                    color: AppColors.toggleScreenLIght(),
                    child: isLoading
                        ? const Center(
                            child: CircularProgressIndicator(
                              color: AppColors.defautlColor,
                            ),
                          )
                        : covarPic != null
                            ? Image.file(covarPic!)
                            : CachedNetworkImage(
                                imageUrl: widget.userModel!.covarImage!,
                                fit: BoxFit.cover,
                                progressIndicatorBuilder:
                                    (context, string, downloadProgress) {
                                  return Center(
                                    child: CircularProgressIndicator(
                                      color: AppColors.defautlColor,
                                      value: downloadProgress.progress,
                                    ),
                                  );
                                },
                                errorWidget: (context, string, some) {
                                  return Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      const Icon(
                                        Icons.error,
                                        color: Colors.red,
                                      ),
                                      Text(
                                        'an error occared',
                                        style: TextStyle(
                                          color: AppColors.textDefultColor(),
                                        ),
                                      ),
                                    ],
                                  );
                                },
                              ),
                  ),
                ),

                //?================================== end covar photo ===========================================

                //* ----------------------------------------------------- profile photo ---------------------------------------------------------------
                Positioned(
                  top: 185,
                  child: GestureDetector(
                    onTap: () {
                      isProfilePic = true;
                      showModalBottomSheet(
                        context: context,
                        builder: (context) => chooseImageOpntions(),
                      ).then((_) {});
                    },
                    child: CircleAvatar(
                      radius: 55.0,
                      backgroundColor: AppColors.toggleScreenLIght(),
                      child: profilePic != null
                          ? CircleAvatar(
                              radius: 50.0,
                              backgroundImage: FileImage(
                                profilePic!,
                              ),
                            )
                          : CircleAvatar(
                              radius: 54.0,
                              backgroundColor: AppColors.toggleScreenLIght(),
                              child: Container(
                                clipBehavior: Clip.antiAliasWithSaveLayer,
                                height: 100.0,
                                width: 100.0,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(
                                    50.0,
                                  ),
                                ),
                                child: CachedNetworkImage(
                                  imageUrl: widget.userModel!.profileImage!,
                                  fit: BoxFit.cover,
                                  progressIndicatorBuilder:
                                      (context, string, downloadProgress) {
                                    return Center(
                                      child: CircularProgressIndicator(
                                        color: AppColors.defautlColor,
                                        value: downloadProgress.progress,
                                      ),
                                    );
                                  },
                                  errorWidget: (context, string, some) {
                                    return Center(
                                      child: Icon(
                                        Icons.error,
                                        color: AppColors.iconColor(),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ),
                    ),
                  ),
                ),

                //?===================================================== end profile photo ==============================================================
              ],
            ),

            //* ----------------------------------------------------------- name ------------------------------------------------------------------------
            Container(
              margin: EdgeInsets.only(
                  top: 50.0, left: MediaQuery.of(context).size.width * 0.04),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    name!.isNotEmpty ? name : widget.userModel!.name as dynamic,
                    style: TextStyle(
                      color: AppColors.textDefultColor(),
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => editNameField(),
                      );
                    },
                    icon: Icon(
                      Icons.edit,
                      color: AppColors.iconColor(),
                    ),
                  ),
                ],
              ),
            ),

            //?================================================== end name ====================================================

            //* ----------------------------------------------------------- gender ----------------------------------------------------------
            Container(
              margin: EdgeInsets.only(
                  left: MediaQuery.of(context).size.width * 0.15),
              child: Row(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Text(
                    gender!.isNotEmpty
                        ? gender
                        : widget.userModel!.gender as dynamic,
                    style: const TextStyle(
                      color: AppColors.defautlColor,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => editGenderField(),
                      );
                    },
                    icon: const Icon(
                      Icons.edit,
                      color: AppColors.defautlColor,
                    ),
                  ),
                ],
              ),
            ),

            //? ======================================= end gender ===================================================
            const SizedBox(
              height: 20.0,
            ),

            //* ----------------------------------------------- bio ---------------------------------------------------------
            Container(
              alignment: Alignment.center,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    bio!.isNotEmpty ? bio : widget.userModel!.bio as dynamic,
                    style: TextStyle(
                        color: AppColors.textDefultColor(),
                        fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (context) => editBioField(),
                      );
                    },
                    icon: Icon(
                      Icons.edit,
                      color: AppColors.iconColor(),
                    ),
                  ),
                ],
              ),
            ),

            //? =========================================== end biio ===============================================
          ],
        ),
      ),
    );
  }

//* ----------------------------------- widget methods ------------------------------------------------

//? this method showing modalbottomsheet with 2 options
//? 1. camera 2. gallery
  Widget chooseImageOpntions() {
    return Container(
      color: AppColors.toggleScreenLIght(),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          GestureDetector(
            onTap: () async {
              setState(() {
                isLoading = true;
              });
              if (isCovarPic) {
                await pickImage(ImageSource.camera).then((value) {
                  accountMethods.updateCovarImage(
                      value, authMethods.currentUser().uid);

                  setState(() {
                    isLoading = false;
                  });
                  isCovarPic = false;
                  Navigator.of(context).pop();
                });
              }
              if (isProfilePic) {
                await pickImage(ImageSource.camera).then((value) {
                  accountMethods.updateProfileImage(
                      value, authMethods.currentUser().uid);

                  setState(() {
                    isLoading = false;
                  });
                  isProfilePic = false;
                  Navigator.of(context).pop();
                });
              }
            },
            child: Container(
              height: 50.0,
              width: 50.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  20.0,
                ),
                border: Border.all(
                  width: 1.0,
                  color: AppColors.iconColor(),
                ),
              ),
              child: Icon(
                Icons.camera_alt_rounded,
                color: AppColors.iconColor(),
              ),
            ),
          ),
          GestureDetector(
            onTap: () async {
              setState(() {
                isLoading = true;
              });
              if (isCovarPic) {
                await pickImage(ImageSource.gallery).then((value) {
                  accountMethods.updateCovarImage(
                      value, authMethods.currentUser().uid);

                  setState(() {
                    isLoading = false;
                  });
                  isCovarPic = false;
                  Navigator.of(context).pop();
                });
              }
              if (isProfilePic) {
                await pickImage(ImageSource.gallery).then((value) {
                  accountMethods.updateProfileImage(
                      value, authMethods.currentUser().uid);

                  setState(() {
                    isLoading = false;
                  });
                  isProfilePic = false;
                  Navigator.of(context).pop();
                });
              }
            },
            child: Container(
              height: 50.0,
              width: 50.0,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(
                  20.0,
                ),
                border: Border.all(
                  width: 1.0,
                  color: AppColors.iconColor(),
                ),
              ),
              child: Icon(
                Icons.image,
                color: AppColors.iconColor(),
              ),
            ),
          ),
        ],
      ),
    );
  }
  //? ============== end chooseImageOption method ==================

//* ------------ custom dialog method --------------------

//this is for chaging name
  Widget editNameField() {
    return Dialog(
      backgroundColor: AppColors.widgetColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          20.0,
        ),
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: 25.0,
              color: AppColors.defautlColor,
              child: Text(
                'edit name',
                style: TextStyle(
                    color: AppColors.textDefultColor(),
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    20.0,
                  ),
                  color: AppColors.widgetColor),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      name = value;
                    });
                  },
                  cursorColor: AppColors.textDefultColor(),
                  style: TextStyle(
                      color: AppColors.textDefultColor(),
                      fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'name',
                    hintStyle: const TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        50.0,
                      ),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        50.0,
                      ),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        name = widget.userModel!.name;
                      });
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 40.0,
                      width: 100.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          30.0,
                        ),
                        border: Border.all(
                          color: Colors.red,
                          width: 1.0,
                        ),
                      ),
                      child: const Text(
                        'cancel',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await accountMethods.updateUserName(
                          name!, authMethods.currentUser().uid);
                      setState(() {
                        Navigator.of(context).pop();
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 40.0,
                      width: 100.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          30.0,
                        ),
                        border: Border.all(
                          color: Colors.green,
                          width: 1.0,
                        ),
                      ),
                      child: Text(
                        isLoading ? 'updating' : 'done',
                        style: const TextStyle(color: Colors.green),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //this is for chaging the gender property
  Widget editGenderField() {
    return Dialog(
      backgroundColor: AppColors.widgetColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          20.0,
        ),
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: 25.0,
              color: AppColors.defautlColor,
              child: Text(
                'edit gender',
                style: TextStyle(
                    color: AppColors.textDefultColor(),
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    20.0,
                  ),
                  color: AppColors.widgetColor),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      gender = value;
                    });
                  },
                  cursorColor: AppColors.textDefultColor(),
                  style: TextStyle(
                      color: AppColors.textDefultColor(),
                      fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'male/female',
                    hintStyle: const TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        50.0,
                      ),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        50.0,
                      ),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        gender = widget.userModel!.gender;
                      });
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 40.0,
                      width: 100.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          30.0,
                        ),
                        border: Border.all(
                          color: Colors.red,
                          width: 1.0,
                        ),
                      ),
                      child: const Text(
                        'cancel',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      await accountMethods.updateGender(
                          gender!, authMethods.currentUser().uid);
                      setState(() {
                        Navigator.of(context).pop();
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 40.0,
                      width: 100.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          30.0,
                        ),
                        border: Border.all(
                          color: Colors.green,
                          width: 1.0,
                        ),
                      ),
                      child: const Text(
                        'done',
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  //this is for chaging bio field
  Widget editBioField() {
    return Dialog(
      backgroundColor: AppColors.widgetColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          20.0,
        ),
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.3,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              alignment: Alignment.center,
              width: double.infinity,
              height: 25.0,
              color: AppColors.defautlColor,
              child: Text(
                'edit bio',
                style: TextStyle(
                    color: AppColors.textDefultColor(),
                    fontSize: 17.0,
                    fontWeight: FontWeight.bold),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    20.0,
                  ),
                  color: AppColors.widgetColor),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      bio = value;
                    });
                  },
                  cursorColor: AppColors.textDefultColor(),
                  style: TextStyle(
                      color: AppColors.textDefultColor(),
                      fontWeight: FontWeight.bold),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'this is...',
                    hintStyle: const TextStyle(color: Colors.grey),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        50.0,
                      ),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        50.0,
                      ),
                      borderSide: const BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        bio = widget.userModel!.bio;
                      });
                      Navigator.of(context).pop();
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 40.0,
                      width: 100.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          30.0,
                        ),
                        border: Border.all(
                          color: Colors.red,
                          width: 1.0,
                        ),
                      ),
                      child: const Text(
                        'cancel',
                        style: TextStyle(color: Colors.red),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      accountMethods.updateBioData(
                          bio!, authMethods.currentUser().uid);
                      setState(() {
                        Navigator.of(context).pop();
                      });
                    },
                    child: Container(
                      alignment: Alignment.center,
                      height: 40.0,
                      width: 100.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(
                          30.0,
                        ),
                        border: Border.all(
                          color: Colors.green,
                          width: 1.0,
                        ),
                      ),
                      child: const Text(
                        'done',
                        style: TextStyle(color: Colors.green),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
//? =================== end custom dialog method ========================

//? ================================= end widget methods =====================================================
}
