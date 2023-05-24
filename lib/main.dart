import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:virtual_council/CustomTheme.dart';
import 'package:virtual_council/Onboarding.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:virtual_council/sign_in.dart';

// Widget defaultRoute = LoginScreen();
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  // final auth = FirebaseAuth.instance;
  // checkSignIn() {
  //   if (auth.currentUser != null) {
  //     defaultRoute = LawDashBoardScreen();
  //   } else {
  //     defaultRoute = defaultRoute;
  //   }
  // }

  // checkSignIn();
  final SharedPreferences sharedPereferences =
      await SharedPreferences.getInstance();
  bool? opened = sharedPereferences.getBool('opened');

  runApp(MaterialApp(
    theme: CustomTheme.lightTheme,
    home: opened == null ? Onboarding() : LoginScreen(),
    debugShowCheckedModeBanner: false,
  ));
}
