import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../themes/app_colors.dart';
import '../people_page/people_tile.dart';
import '../../providers/people_methods.dart';
import '../../providers/auth_methods.dart';
import '../../models/user_model.dart';

class PeoplePage extends StatefulWidget {
  PeoplePage({Key? key}) : super(key: key);

  @override
  State<PeoplePage> createState() => _PeoplePageState();
}

class _PeoplePageState extends State<PeoplePage> {
  var seachedText = '';

  List<UserModel> userList = [];


  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final peopleMethods = Provider.of<PeopleMethods>(context, listen: false);
    final authMethods = Provider.of<AuthMethods>(context, listen: false);
    peopleMethods
        .fetchAllUsers(currentUserId: authMethods.currentUser().uid)
        .then((users) {
      setState(() {
        userList = users;
      });
    });

    final List<UserModel> suggestionList = seachedText.isEmpty
        ? userList
        : userList.where((users) {
            String username = users.name!.toLowerCase();
            String inputText = seachedText.toLowerCase();
            bool matchName = username.contains(inputText);

            return matchName;
          }).toList();
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              onChanged: (value) {
                seachedText = value;
              },
              style: TextStyle(
                color: AppColors.textDefultColor(),
              ),
              decoration: InputDecoration(
                hintText: 'search peoples',
                hintStyle: const TextStyle(
                  color: Colors.grey,
                ),
                isDense: true,
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    40.0,
                  ),
                  borderSide: const BorderSide(
                    color: AppColors.defautlColor,
                    width: 1.0,
                  ),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(
                    40.0,
                  ),
                  borderSide: const BorderSide(
                    color: AppColors.defautlColor,
                    width: 1.0,
                  ),
                ),
                border: InputBorder.none,
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: suggestionList.length,
              itemBuilder: (context, index) {
                UserModel userModel = UserModel(
                  bio: suggestionList[index].bio,
                  covarImage: suggestionList[index].covarImage,
                  gender: suggestionList[index].gender,
                  id: suggestionList[index].id,
                  name: suggestionList[index].name,
                  profileImage: suggestionList[index].profileImage,
                );
                return  PeopleTile(userModel);
              },
            ),
          ),
        ],
      ),
    );
  }
}
