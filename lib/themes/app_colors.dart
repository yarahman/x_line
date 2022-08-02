import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppColors {
  //* colors ------------------------------------------------->
  static const lightColor = Colors.white;
  static const darkColor = Colors.black;
  static const defautlColor = Color(
    0xffF26351,
  );
  static const sndDefaultColor = Color.fromARGB(255, 255, 251, 0);

  //*this is statusBar color->
  static var statusbarColor = SystemChrome.setSystemUIOverlayStyle(
    SystemUiOverlayStyle(
      statusBarColor: Colors.white.withOpacity(0.0),
    ),
  );

//?============================== end color ================================
//* varibles --------------------------------------------------------------------------->
  static var isDark = true;

//? ============================ end varibals =========================

  //? all methods ----------------->
  static Color toggleScreenLIght() => isDark ? darkColor : lightColor;

//* when app is dark mode
//* all default text going to white and so on
  static Color textDefultColor() => isDark ? lightColor : darkColor;

//* responsible for all text field fill color
  static Color textFieldColor() => isDark ? Colors.black : Colors.white;

  static Color iconColor() => isDark ? Colors.white : Colors.black;

  static Color textFieldShadowColor = Colors.grey;

  static Color widgetColor =
      isDark ? const Color.fromARGB(255, 22, 22, 22) : Colors.white;

  static Color tabBarColor = isDark
      ? const Color.fromARGB(255, 26, 26, 26)
      : const Color.fromARGB(255, 211, 211, 211);
}
