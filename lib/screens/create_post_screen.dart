import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import '../themes/app_colors.dart';
import '../providers/account_methods.dart';
import '../providers/auth_methods.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  State<CreatePostScreen> createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
//* -------------------------------------- global variables ---------------------------------------------

  File? image;
  String text = '';
  var isBannerShowing = false;
  AccountMethods? accountMethods;
  AuthMethods? authMethods;
  var isLoading = false;
  int likeCount = 0;

//? ########################### end global variables ########################\

//* ------------------------------------------- method / functions -------------------------------------------

  Future<void> pickImage(ImageSource source) async {
    final instance = ImagePicker();

    final pickImage = await instance.pickImage(source: source);

    File img = File(pickImage!.path);

    setState(() {
      image = img;
    });
  }

  Future<void> onSubmit() async {
    if (text.length < 5 && image == null) {
      return showErrorBanner();
    }

    setState(() {
      isLoading = true;
    });

    await accountMethods!.uploadPostToDb(
      currentUserId: authMethods!.currentUser().uid,
      image: image,
      message: text,
      likes: <String, dynamic>{},
      likeCount: likeCount,
    );

    setState(() {
      isLoading = false;
      Navigator.of(context).pop();
    });
  }

//? ############################## end methods / functions ########################

//* ------------------------------------------ widget methods / functions ----------------------------------------
  void showErrorBanner() {
    setState(() {
      isBannerShowing = true;
    });
    ScaffoldMessenger.of(context).showMaterialBanner(
      MaterialBanner(
        elevation: 5.0,
        leading: Icon(
          Icons.error_outline_sharp,
          color: AppColors.iconColor(),
        ),
        padding: const EdgeInsets.symmetric(vertical: 5.0),
        backgroundColor: Colors.red,
        content: Text(
          'text must be gratter than 6 latter',
          style: TextStyle(
            color: AppColors.textDefultColor(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
              setState(() {
                isBannerShowing = false;
              });
            },
            child: Text(
              'close',
              style: TextStyle(
                color: AppColors.textDefultColor(),
              ),
            ),
          ),
        ],
      ),
    );
  }

//?##################################### end widget methods / functions ##################################

  @override
  Widget build(BuildContext context) {
    accountMethods = Provider.of<AccountMethods>(context, listen: false);
    authMethods = Provider.of<AuthMethods>(context);
    return Scaffold(
      backgroundColor: AppColors.toggleScreenLIght(),
//? ----------------------------------------------------------------- the app bar --------------------------------------------------------------------------
      appBar: AppBar(
        backgroundColor: AppColors.toggleScreenLIght(),
        title: Text(
          'create post',
          style: TextStyle(
            color: AppColors.textDefultColor(),
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: ElevatedButton(
              style: ButtonStyle(
                backgroundColor: (image == null && text.isEmpty)
                    ? MaterialStateProperty.all(
                        AppColors.defautlColor.withOpacity(
                          0.2,
                        ),
                      )
                    : MaterialStateProperty.all(AppColors.defautlColor),
              ),
              onPressed: (image == null && text.isEmpty)
                  ? null
                  : isBannerShowing
                      ? null
                      : onSubmit,
              child: Text(
                isLoading ? 'uploading' : 'send',
                style: TextStyle(
                  color: (image == null && text.isEmpty)
                      ? AppColors.textDefultColor().withOpacity(
                          0.2,
                        )
                      : AppColors.textDefultColor(),
                ),
              ),
            ),
          ),
        ],
      ),

//* ####################################################### end of the app bar ###########################################
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
//? ------------------------------------------------------------ text input field ------------------------------------------------------------------
                  if (isBannerShowing)
                    const SizedBox(
                      height: 80.0,
                    ),
                  Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: TextField(
                      onChanged: (value) {
                        setState(() {
                          text = value;
                        });
                        print(text);
                      },
                      keyboardType: TextInputType.multiline,
                      cursorColor: AppColors.textDefultColor(),
                      style: TextStyle(
                        color: AppColors.textDefultColor(),
                      ),
                      maxLines: image != null ? 3 : 20,
                      decoration: InputDecoration(
                        hintText: image != null
                            ? 'talk about this photo'
                            : 'whats on you mind!',
                        hintStyle: const TextStyle(color: Colors.grey),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            20.0,
                          ),
                          borderSide: BorderSide(
                            color: AppColors.defautlColor.withOpacity(0.5),
                            width: 1.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(
                            20.0,
                          ),
                          borderSide: const BorderSide(
                            color: AppColors.defautlColor,
                            width: 1.0,
                          ),
                        ),
                      ),
                    ),
                  ),
//* ############################################# end text input field #################################

//? -------------------------------------------------------------- showing image --------------------------------------------------------------------
                  if (image != null)
                    Stack(
                      alignment: Alignment.bottomCenter,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(7.0),
                          child: Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                10.0,
                              ),
                              border: Border.all(
                                  width: 1.0, color: AppColors.defautlColor),
                            ),
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(10.0),
                              child: Image.file(image!),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 10.0,
                          child: FloatingActionButton.small(
                            backgroundColor:
                                AppColors.defautlColor.withOpacity(0.6),
                            onPressed: () {
                              setState(() {
                                image = null;
                              });
                            },
                            child: Icon(
                              Icons.clear,
                              color: AppColors.iconColor(),
                            ),
                          ),
                        ),
                      ],
                    ),
//*####################################### end of showing image ############################################
                ],
              ),
            ),
          ),

//? ---------------------------------------------------------- bottom buttons ---------------------------------------------------------
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              //! camera button
              TextButton.icon(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    AppColors.widgetColor.withOpacity(
                      0.1,
                    ),
                  ),
                  elevation: MaterialStateProperty.all(
                    5.0,
                  ),
                ),
                onPressed: image != null
                    ? null
                    : () {
                        pickImage(ImageSource.camera);
                      },
                icon: Icon(
                  Icons.camera_alt_rounded,
                  color: image != null
                      ? AppColors.iconColor().withOpacity(0.2)
                      : AppColors.iconColor(),
                ),
                label: Text(
                  'camera',
                  style: TextStyle(
                    color: image != null
                        ? AppColors.textDefultColor().withOpacity(0.2)
                        : AppColors.textDefultColor(),
                  ),
                ),
              ),

              //! gallery button
              TextButton.icon(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(
                    AppColors.widgetColor.withOpacity(
                      0.1,
                    ),
                  ),
                  elevation: MaterialStateProperty.all(
                    5.0,
                  ),
                ),
                onPressed: image != null
                    ? null
                    : () {
                        pickImage(ImageSource.gallery);
                      },
                icon: Icon(
                  Icons.image_sharp,
                  color: image != null
                      ? AppColors.iconColor().withOpacity(0.2)
                      : AppColors.iconColor(),
                ),
                label: Text(
                  'gallery',
                  style: TextStyle(
                    color: image != null
                        ? AppColors.textDefultColor().withOpacity(0.2)
                        : AppColors.textDefultColor(),
                  ),
                ),
              ),
            ],
          ),
//*######################################## end of bottom buttons ##########################################
        ],
      ),
    );
  }
}
