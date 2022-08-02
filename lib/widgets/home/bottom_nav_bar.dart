import 'package:flutter/material.dart';
import 'package:x_line/themes/app_colors.dart';

class BottomNavBar extends StatelessWidget {
  const BottomNavBar(
      {this.accountColor,
      this.accountOnTap,
      this.chatColor,
      this.chatOnTap,
      this.peopleColor,
      this.peopleOnTap,
      this.storyColor,
      this.storyOnTap});
  final VoidCallback? chatOnTap;
  final VoidCallback? peopleOnTap;
  final VoidCallback? storyOnTap;
  final VoidCallback? accountOnTap;
  final Color? chatColor;
  final Color? peopleColor;
  final Color? storyColor;
  final Color? accountColor;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      elevation: 5.0,
      shape: const CircularNotchedRectangle(),
      notchMargin: 5,
      color: AppColors.tabBarColor,
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.chat,
                    color: chatColor,
                  ),
                  onPressed: chatOnTap,
                ),
                IconButton(
                  icon: Icon(
                    Icons.people,
                    color: peopleColor,
                  ),
                  onPressed: peopleOnTap,
                ),
              ],
            ),
          ),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.4,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                IconButton(
                  icon: Icon(
                    Icons.sports_basketball_rounded,
                    color: storyColor,
                  ),
                  onPressed: storyOnTap,
                ),
                IconButton(
                  icon: Icon(
                    Icons.account_circle,
                    color: accountColor,
                  ),
                  onPressed: accountOnTap,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
