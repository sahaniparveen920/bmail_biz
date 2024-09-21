import 'package:flutter/material.dart';

class OnboardController {
  final PageController pageControl = PageController();

  // Current selected page index
  int selectedPageIndex = 0;

  // Dummy data for onboarding pages (replace with actual data)
  final List<OnBoardPage> onBoardPages = [
    OnBoardPage(
      image: 'assets/images/onboard/onboard1.png',
      title: 'Welcome',
      subTitle: 'Welcome to seamless email communication',
    ),
    OnBoardPage(
      image: 'assets/images/onboard/onboard2.png',
      title: 'Learn',
      subTitle: 'Discover features that enhance your inbox',
    ),
    OnBoardPage(
      image: 'assets/images/onboard/onboard3.png',
      title: 'Start',
      subTitle: 'Get started with B-Mail in minutes',
    ),
    OnBoardPage(
      image: 'assets/images/onboard/onboard4.png',
      title: 'Explore Bmail',
      subTitle: 'Explore B-Mail: Your smarter email solution',
    ),
  ];

  // Method to update the selected page index
  void selectedPagexNumber(int index) {
    selectedPageIndex = index;
  }

  // Method to move to the next page or finish onboarding
  void forwardAct() {
    if (selectedPageIndex < onBoardPages.length - 1) {
      pageControl.nextPage(
          duration: Duration(milliseconds: 300), curve: Curves.easeIn);
    } else {
      // Add your logic to navigate to the next screen after onboarding is complete
      print("Onboarding finished");
    }
  }

  // Method to skip onboarding and go to the intro screen
  void goToIntroScreen() {
    // Add your logic to navigate to the intro screen
    print("Skipping onboarding");
  }
}

// Data model for an onboarding page
class OnBoardPage {
  final String image;
  final String title;
  final String subTitle;

  OnBoardPage({
    required this.image,
    required this.title,
    required this.subTitle,
  });
}
