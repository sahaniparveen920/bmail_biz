import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/onboard_controller.dart';
import '../routes/routes.dart';
import '../utils/custom_color.dart';
import '../utils/dimensions.dart';
import '../utils/strings.dart';
import '../view/auth/sign_in_screen.dart';

class OnBoardScreen extends StatefulWidget {
  const OnBoardScreen({Key? key}) : super(key: key);

  @override
  _OnBoardScreenState createState() => _OnBoardScreenState();
}

class _OnBoardScreenState extends State<OnBoardScreen> {
  final onBoardController = OnboardController();
  int currentIndex = 0; // To track the current page index

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: CustomColor.white,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.7,
              child: PageView.builder(
                controller: onBoardController.pageControl,
                onPageChanged: (index) {
                  setState(() {
                    currentIndex = index; // Update the current index
                  });
                  onBoardController.selectedPagexNumber(index); // Call the method in your controller if needed
                },
                itemCount: onBoardController.onBoardPages.length,
                itemBuilder: (context, index) => Padding(
                  padding: const EdgeInsets.only(left: 10, right: 10),
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Image.asset(
                          onBoardController.onBoardPages[index].image,
                          height: MediaQuery.of(context).size.height * .5,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Text(
                            onBoardController.onBoardPages[index].title,
                            style: TextStyle(
                              fontSize: Dimensions.defaultTextSize,
                              color: CustomColor.black300,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        SizedBox(height: Dimensions.marginSize - 10),
                        Padding(
                          padding: const EdgeInsets.only(left: 20, right: 20),
                          child: Text(
                            onBoardController.onBoardPages[index].subTitle,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: Dimensions.defaultTextSize,
                              color: Colors.black,
                            ),
                          ),
                        ),
                        SizedBox(height: Dimensions.marginSize * 2),
                        SizedBox(
                          width: MediaQuery.of(context).size.width,
                          child: Align(
                            alignment: Alignment.center,
                            child: Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Center(
                                child: SizedBox(
                                  width: 100.0,
                                  height: 13.0,
                                  child: ListView.builder(
                                    itemCount: onBoardController.onBoardPages.length,
                                    shrinkWrap: true,
                                    scrollDirection: Axis.horizontal,
                                    itemBuilder: (context, i) {
                                      return Padding(
                                        padding: const EdgeInsets.only(right: 15.0),
                                        child: Container(
                                          width: currentIndex == i ? 13 : 13.0,
                                          decoration: BoxDecoration(
                                            color: currentIndex == i
                                                ? CustomColor.secondaryColor
                                                : CustomColor.black100.withOpacity(0.2),
                                            borderRadius: const BorderRadius.all(Radius.circular(13.0)),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: MediaQuery.of(context).size.height * 0.2,
              padding: EdgeInsets.symmetric(
                horizontal: Dimensions.defaultPaddingSize * 0.7,
                vertical: Dimensions.defaultPaddingSize * 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  InkWell(
                    onTap: () {
                      onBoardController.goToIntroScreen();
                    },
                    child: const Text(
                      Strings.skip,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      if (currentIndex == onBoardController.onBoardPages.length - 1) {
                        // If on the last page, navigate to SignInScreen
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => SignInScreen()),
                        );
                      } else {
                        // Otherwise, move to the next page
                        onBoardController.forwardAct();
                      }
                    },
                    child: Text(
                      currentIndex == onBoardController.onBoardPages.length - 1
                          ? Strings.finish
                          : Strings.next,
                      textAlign: TextAlign.right,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: CustomColor.accentColor,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Example function for handling user registration
Future<void> _registerUser() async {
  // Perform the registration logic, e.g., API call

  // After successful registration
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool('hasAccount', true);

  // Navigate to the dashboard or another appropriate screen
  Get.offAllNamed(Routes.bmailmainpage); // Or any other screen
}


