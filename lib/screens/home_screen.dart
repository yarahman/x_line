import 'package:flutter/material.dart';

import '../themes/app_colors.dart';
import '../widgets/home/bottom_nav_bar.dart';
import '../widgets/home/account_page.dart';
import '../widgets/home/chat_page.dart';
import '../widgets/home/news_feeds_page.dart';
import '../widgets/home/people_page.dart';
import '../widgets/home/game_page.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
//* -------------------------------------------- global variabls ------------------------------------
  var isHomeSreen = false;
  var isChatScreen = false;
  var isPeopleScreen = false;
  var isStoryScreen = false;
  var isAccountScreen = false;

//? =================================== end Global variables =====================================

//------------------------------------------ flutter default methods -------------------------------------------------------

  @override
  void initState() {
    isHomeSreen = true;
    super.initState();
  }

//? ============================================ end flutter default methods ===========================

  @override
  Widget build(BuildContext context) {
    AppColors.statusbarColor;
    return Scaffold(
      backgroundColor: AppColors.toggleScreenLIght(),
      extendBody: true,
      body: isHomeSreen
          ? NewsFeedsPage()
          : isChatScreen
              ? const ChatPage()
              : isPeopleScreen
                  ? PeoplePage()
                  : isStoryScreen
                      ? const GamePage()
                      : isAccountScreen
                          ? AccountPage()
                          : Container(),

      //* -------------------------------------------- bottom tab bar ----------------------------------------------------------------------
      floatingActionButton: bottomHomeButton(
          onTap: () {
            setState(() {
              isHomeSreen = true;
              isChatScreen = false;
              isPeopleScreen = false;
              isStoryScreen = false;
              isAccountScreen = false;
            });
          },
          iconColor: Colors.white,
          backgoundColor: isHomeSreen ? AppColors.defautlColor : Colors.grey),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: BottomNavBar(
        chatOnTap: () {
          setState(() {
            isHomeSreen = false;
            isChatScreen = true;
            isPeopleScreen = false;
            isStoryScreen = false;
            isAccountScreen = false;
          });
        },
        peopleOnTap: () {
          setState(() {
            isHomeSreen = false;
            isChatScreen = false;
            isPeopleScreen = true;
            isStoryScreen = false;
            isAccountScreen = false;
          });
        },
        storyOnTap: () {
          setState(() {
            isHomeSreen = false;
            isChatScreen = false;
            isPeopleScreen = false;
            isStoryScreen = true;
            isAccountScreen = false;
          });
        },
        accountOnTap: () {
          setState(() {
            isHomeSreen = false;
            isChatScreen = false;
            isPeopleScreen = false;
            isStoryScreen = false;
            isAccountScreen = true;
          });
        },
        chatColor: isChatScreen ? AppColors.defautlColor : Colors.white,
        peopleColor: isPeopleScreen ? AppColors.defautlColor : Colors.white,
        storyColor: isStoryScreen ? AppColors.defautlColor : Colors.white,
        accountColor: isAccountScreen ? AppColors.defautlColor : Colors.white,
      ),
      //?=========================================== end bottom tab bar =========================================
    );
  }

  //* ------------------------------------------ widget method -------------------------------------------

//! this is the "home floating aciton button"
  Widget bottomHomeButton(
      {required VoidCallback onTap, Color? backgoundColor, Color? iconColor}) {
    return FloatingActionButton(
      onPressed: onTap,
      backgroundColor: backgoundColor,
      child: Icon(
        Icons.home,
        color: iconColor,
      ),
    );
  }
//? ==================================== end of widget methods =================================
}
