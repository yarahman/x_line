import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// ignore: depend_on_referenced_packages
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:x_line/screens/auth_screen.dart';
import 'package:x_line/screens/home_screen.dart';

import './providers/auth_methods.dart';
import './providers/account_methods.dart';
import './themes/app_colors.dart';
import './providers/home_methods.dart';
import './providers/people_methods.dart';
import './providers/chat_methods.dart';
import './providers/games_methods.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => AuthMethods(),
        ),
        ChangeNotifierProvider(
          create: (context) => AccountMethods(),
        ),
        ChangeNotifierProvider(
          create: (context) => HomeMethods(),
        ),
        ChangeNotifierProvider(
          create: (context) => PeopleMethods(),
        ),
        ChangeNotifierProvider(
          create: (context) => ChatMethods(),
        ),
        ChangeNotifierProvider(
          create: (context) => GameMethods(),
        ),
      ],
      child: MaterialApp(
        darkTheme: ThemeData.light(),
        theme: ThemeData(
          colorScheme: ColorScheme.fromSwatch().copyWith(
            secondary: AppColors.sndDefaultColor,
          ),
        ),
        debugShowCheckedModeBanner: false,
        home: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapShot) {
            if (snapShot.hasData) {
              return const HomeScreen();
            }
            return const HomeScreen();
          },
        ),
      ),
    );
  }
}
