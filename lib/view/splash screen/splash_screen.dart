import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../routes/routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);


  @override
  Splash createState() => Splash();
}

class Splash extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _goToScreen(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  "assets/Bmail_Logo_Gif-full.gif",
                  width: MediaQuery.of(context).size.width * .5,
                  height: MediaQuery.of(context).size.width * .45,
                  alignment: Alignment.center,
                  fit: BoxFit.fill,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _goToScreen(BuildContext context) async {
    print("Checking user status and navigating...");

    // Get shared preferences
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Retrieve the email from shared preferences to check if user is logged in
    String? email = prefs.getString('user_token');

    // Simulate a delay for splash screen
    await Future.delayed(const Duration(seconds: 3));

    // Navigate based on the presence of the email
    if (email != null&& email.isNotEmpty) {
      // User is not logged in, navigate to the sign-in screen
      Get.offAllNamed(Routes.bmailmainpage);
       // Ensure Routes.signInScreen is correctly defined
    } else {
      // User is logged in, navigate to the main page
       // Ensure Routes.bmailmainpage is correctly defined
      Get.offAllNamed(Routes.signInScreen);
    }
  }
}


