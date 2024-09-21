import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import '../view/bottom_navigation/gmail_page/bmail_main_page.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.indigo, Colors.blueGrey], // Updated background colors
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Smaller Logo or Image
            Image.asset(
              'assets/gmail.webp',
              height: 80, // Reduced icon size
            ),
            SizedBox(height: 30), // Adjusted space

            // Updated Welcome Title
            Text(
              "Welcome to Bmail!",
              style: TextStyle(
                fontSize: 28, // Reduced text size
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 1.1,
                shadows: [
                  Shadow(
                    blurRadius: 6.0,
                    color: Colors.black26,
                    offset: Offset(2.0, 2.0),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),

            // Updated Subtitle Text
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0),
              child: Text(
                "We're excited to have you onboard. Your journey starts here.",
                style: TextStyle(
                  fontSize: 16, // Reduced text size
                  color: Colors.white.withOpacity(0.9),
                  height: 1.5,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            SizedBox(height: 40), // Adjusted space

            // Updated Get Started Button
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14, horizontal: 28), // Slightly smaller button
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
                backgroundColor: Colors.white,
              ),
              onPressed: () async {
                SharedPreferences prefs = await SharedPreferences.getInstance();
                await prefs.setBool('welcome_shown', true);

                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => BmailMainPage()),
                );
              },
              child: Text(
                "Get Started",
                style: TextStyle(
                  color: Colors.indigo, // Updated text color to match background
                  fontSize: 16, // Reduced button text size
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
