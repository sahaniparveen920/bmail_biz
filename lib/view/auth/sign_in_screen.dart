import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../routes/routes.dart';
import '../../utils/custom_color.dart';
import '../../utils/dimensions.dart';
import '../../utils/strings.dart';
import '../../widgets/buttons/primary_button_widget.dart';

// Initialize controllers
final TextEditingController mobileController = TextEditingController();
final TextEditingController otpController = TextEditingController();
final ValueNotifier<int> userOtpController = ValueNotifier<int>(0);
final TextEditingController resetpassworController = TextEditingController();


class HomeController extends GetxController {
  final loginFormKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
}

class SignInScreen extends StatefulWidget {
  @override
  _SignInScreenState createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final HomeController controller = Get.put(HomeController());
  // List<Color> colors = [
  //   Colors.blue.shade100,
  //   Colors.green.shade100,
  //   Colors.purple.shade100,
  //   Colors.orange.shade100,
  //   Colors.red.shade100,
  //   Colors.yellowAccent.shade100,
  //   Colors.indigoAccent.shade100,
  //   Colors.pinkAccent.shade100,
  //   Colors.cyan.shade100
  // ];
  int colorIndex = 0;

  @override
  void initState() {
    super.initState();
    // _changeColor();
    controller.emailController.addListener(_updateEmailSuffix);
  }

  // void _changeColor() {
  //   Future.delayed(Duration(seconds: 1), () {
  //     setState(() {
  //       colorIndex = (colorIndex + 1) % colors.length;
  //     });
  //     _changeColor();
  //   });
  // }

  void _updateEmailSuffix() {
    final text = controller.emailController.text;

    // Check if the text does not already end with '@bmail.biz'
    if (!text.endsWith('@bmail.biz')) {
      // Only add '@bmail.biz' if user has typed something
      if (text.isNotEmpty && !text.contains('@')) {
        // Remove any existing '@bmail.biz' from the text
        final updatedText = text.replaceAll('@bmail.biz', '');

        // Update the text in the controller with the suffix added
        controller.emailController.value = controller.emailController.value.copyWith(
          text: updatedText + '@bmail.biz',
          selection: TextSelection.fromPosition(
            TextPosition(offset: updatedText.length),
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    controller.emailController.removeListener(_updateEmailSuffix);
    controller.emailController.dispose();
    controller.passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.defaultPaddingSize),
          child: Center(
            child: ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              children: [
                SizedBox(height: Dimensions.heightSize * 2),
                Container(
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2), // Semi-transparent color
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  padding: EdgeInsets.all(Dimensions.defaultPaddingSize),
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/gmail.webp",
                        width: MediaQuery.of(context).size.width * .25,
                        height: MediaQuery.of(context).size.width * .25,
                        alignment: Alignment.center,
                      ),
                      SizedBox(height: Dimensions.heightSize * 2),
                      Text(
                        "SIGN IN",
                        style: TextStyle(
                          color: Colors.deepOrange.shade400,
                          fontSize: 36,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(height: Dimensions.heightSize * 2),
                      Form(
                        key: controller.loginFormKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: _buildTextField(
                                controller: controller.emailController,
                                hintText: Strings.enterEmail,
                                labelText: Strings.email,
                                keyboardType: TextInputType.emailAddress,
                                icon: Icons.email,
                                isEmail: true,
                              ),
                            ),
                            SizedBox(height: Dimensions.heightSize * 1),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: _buildTextField(
                                controller: controller.passwordController,
                                hintText: Strings.enterPassword,
                                labelText: Strings.password,
                                obscureText: true,
                                keyboardType: TextInputType.text,
                                icon: Icons.lock,
                              ),
                            ),
                            SizedBox(height: Dimensions.marginSize - 20),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    showForgetDialog(context, controller.emailController);
                                  },
                                  child: Text(
                                    Strings.forgotPassword,
                                    style: GoogleFonts.roboto(
                                      fontSize: Dimensions.smallTextSize,
                                      color: CustomColor.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: Dimensions.heightSize * 2),
                            _buttonWidget(context),
                            SizedBox(height: Dimensions.heightSize * 2),
                            _donTHaveAccountWidget(context),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required String labelText,
    required TextInputType keyboardType,
    required IconData icon,
    bool obscureText = false,
    bool isEmail = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        prefixIcon: Icon(icon),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter $labelText';
        }
        return null;
      },
    );
  }


  Widget _buttonWidget(BuildContext context) {
    return Column(
      children: [
        PrimaryButtonWidget(
          title: Strings.signIn,
          onPressed: () async {
            SharedPreferences prefs = await SharedPreferences.getInstance();
            String? savedEmail = prefs.getString('user_email');
            String? savedPassword = prefs.getString('user_password');
            String? savedId = prefs.getString('user_Id');
            String? savedName = prefs.getString('user_name');

            print('Saved ID: $savedId');
            print('Saved Name: $savedName');
            print('Saved Password: $savedPassword');

            if (savedEmail != null && savedPassword != null) {
              controller.emailController.text = savedEmail;
              controller.passwordController.text = savedPassword;
            }

            if (savedId != null) {
              Get.offAllNamed(Routes.bmailmainpage);
              return;
            }

            if (controller.loginFormKey.currentState!.validate()) {
              final email = controller.emailController.text;
              final password = controller.passwordController.text;

              try {
                final response = await http.post(
                  Uri.parse('https://apiv2.bmail.biz/login'),
                  headers: {'Content-Type': 'application/json'},
                  body: jsonEncode({
                    'email': email,
                    'password': password,
                  }),
                );

                print('Response status: ${response.statusCode}');
                print('Response body: ${response.body}');

                if (response.statusCode == 200) {
                  final responseData = jsonDecode(response.body);

                  if (responseData.containsKey('data') && responseData['data']['id'] != null) {
                    final id = responseData['data']['id'];
                    final name = responseData['data']['name'];
                    final email = responseData['data']['email'];
                    final token = responseData['data']['token'];

                    final SharedPreferences prefs = await SharedPreferences.getInstance();
                    await prefs.setInt('user_id', id);
                    await prefs.setString('user_name', name);
                    await prefs.setString('user_email', email);
                    await prefs.setString('user_token', token);

                    print('Saved ID after login: $id');
                    print('Saved Name after login: $name');
                    print('Saved Email after login: $email');
                    print('Saved Token after login: $token');

                    Get.offAllNamed(Routes.welcomePage);
                  } else {
                    Get.snackbar(
                      'Error',
                      'Login failed. User data not found in the response.',
                      snackPosition: SnackPosition.BOTTOM,
                      backgroundColor: Colors.redAccent,
                      colorText: Colors.white,
                      duration: const Duration(seconds: 3),
                    );
                  }
                } else {
                  final errorResponse = jsonDecode(response.body);
                  Get.snackbar(
                    'Error',
                    'Error: ${errorResponse['message']}',
                    snackPosition: SnackPosition.BOTTOM,
                    backgroundColor: Colors.redAccent,
                    colorText: Colors.white,
                    duration: const Duration(seconds: 3),
                  );
                }
              } catch (e) {
                Get.snackbar(
                  'Error',
                  'An unexpected error occurred: $e',
                  snackPosition: SnackPosition.BOTTOM,
                  backgroundColor: Colors.redAccent,
                  colorText: Colors.white,
                  duration: const Duration(seconds: 3),
                );
              }
            }
          },
        ),
        SizedBox(height: Dimensions.heightSize * .5),
      ],
    );
  }

  void showForgetDialog(BuildContext context, TextEditingController emailController) {
    AlertDialog alert = AlertDialog(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
      content: Padding(
        padding: const EdgeInsets.all(5),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                "assets/gmail.webp",
                width: MediaQuery.of(context).size.width * .2,
                height: MediaQuery.of(context).size.width * .2,
                alignment: Alignment.center,
              ),
              SizedBox(height: Dimensions.marginSize),
              Text(
                Strings.forgotPassword,
                style: GoogleFonts.roboto(
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: Dimensions.marginSize - 18),
              Text(
                Strings.enterYourEmailForPasswordLink,
                textAlign: TextAlign.center,
                style: GoogleFonts.roboto(color: Colors.black54),
              ),
              SizedBox(height: Dimensions.marginSize - 18),
              _buildTextField(
                controller: emailController,
                hintText: Strings.enterEmail,
                labelText: Strings.email,
                keyboardType: TextInputType.emailAddress,
                icon: Icons.email_sharp,
              ),
              SizedBox(height: Dimensions.heightSize * 2),
              _buildTextField(
                controller: mobileController,
                hintText: Strings.enterPhoneNumber,
                labelText: Strings.phone,
                keyboardType: TextInputType.phone,
                icon: Icons.phone,
              ),
              SizedBox(height: Dimensions.heightSize * 2),
              PrimaryButtonWidget(
                title: Strings.submit,
                onPressed: () async {
                  if (emailController.text.isNotEmpty) {
                    // Replace with the new forgot password API if necessary
                    final response = await http.post(
                      Uri.parse('https://apiv2.bmail.biz/forget'),
                      headers: {'Content-Type': 'application/json'},
                      body: jsonEncode({
                        "action": "send_otp",
                        "email": emailController.text,
                        "mobile": mobileController.text,
                      }),
                    );
                    print(response.body);
                    if (response.statusCode == 200) {
                      Navigator.pop(context);
                      showDialog(
                        context: context,
                        barrierDismissible: false,
                        builder: (context) => AlertDialog(
                          backgroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(20.0)),
                          ),
                          content: SingleChildScrollView(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  "assets/gmail.webp",
                                  width: MediaQuery.of(context).size.width * .2,
                                  height: MediaQuery.of(context).size.width * .2,
                                  alignment: Alignment.center,
                                ),
                                SizedBox(height: Dimensions.marginSize),
                                Text(
                                  Strings.resetPassword,
                                  style: GoogleFonts.roboto(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(height: Dimensions.marginSize - 18),
                                Text(
                                  Strings.enterYourEmailForPasswordLink,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.roboto(color: Colors.black54),
                                ),
                                SizedBox(height: Dimensions.marginSize - 18),
                                _buildTextField(
                                  controller: emailController,
                                  hintText: Strings.enterPhoneNumber,
                                  labelText: Strings.email,
                                  keyboardType: TextInputType.emailAddress,
                                  icon: Icons.email_sharp,
                                ),
                                SizedBox(height: Dimensions.marginSize - 18),
                                _buildTextField(
                                  controller: otpController,
                                  hintText: Strings.enterOtp,
                                  labelText: Strings.otp,
                                  keyboardType: TextInputType.number,
                                  icon: Icons.confirmation_number,
                                ),
                                SizedBox(height: Dimensions.marginSize - 18),
                                _buildTextField(
                                  controller: resetpassworController,
                                  hintText: Strings.enterNewPassword,
                                  labelText: Strings.newPassword,
                                  keyboardType: TextInputType.phone,
                                  icon: Icons.lock_open_rounded,
                                ),
                                SizedBox(height: Dimensions.heightSize * 2),
                                PrimaryButtonWidget(
                                  title: Strings.submit,
                                  onPressed: () async {
                                    if (emailController.text.isNotEmpty && otpController.text.isNotEmpty && resetpassworController.text.isNotEmpty) {
                                      final response = await http.post(
                                        Uri.parse('https://petdoctorindia.in/forget'),
                                        headers: {'Content-Type': 'application/json'},
                                        body: jsonEncode({
                                          'action': 'reset_password',
                                          'email': emailController.text,
                                          'otp': otpController.text,
                                          'new_password': resetpassworController.text,
                                        }),
                                      );

                                      print(response.body);

                                      if (response.statusCode == 200) {
                                        Navigator.pop(context); // Close the dialog
                                        Get.snackbar(
                                          'Success',
                                          'Password changed successfully.',
                                          snackPosition: SnackPosition.BOTTOM,
                                          backgroundColor: Colors.green,
                                          colorText: Colors.white,
                                          duration: const Duration(seconds: 3),
                                        );
                                      } else {
                                        Get.snackbar(
                                          'Error',
                                          'Failed to change password. Please try again.',
                                          snackPosition: SnackPosition.BOTTOM,
                                          backgroundColor: Colors.redAccent,
                                          colorText: Colors.white,
                                          duration: const Duration(seconds: 3),
                                        );
                                      }
                                    } else {
                                      Get.snackbar(
                                        'Error',
                                        'Please fill in all fields.',
                                        snackPosition: SnackPosition.BOTTOM,
                                        backgroundColor: Colors.redAccent,
                                        colorText: Colors.white,
                                        duration: const Duration(seconds: 3),
                                      );
                                    }
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    }
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  Widget _donTHaveAccountWidget(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.signUpScreen);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'Create new account?',
            style: TextStyle(
              fontSize: 13,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(width: 10),
          GestureDetector(
            onTap: () {
              Get.toNamed(Routes.signUpScreen); // Navigate to sign-in screen
            },
            child: Text(
              'Signup',
              style: TextStyle(
                fontSize: 13,
                color: CustomColor.white, // Assuming CustomColor.secondaryColor is defined
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}



