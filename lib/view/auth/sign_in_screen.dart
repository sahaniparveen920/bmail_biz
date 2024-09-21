import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../routes/routes.dart';
import '../../utils/custom_color.dart';
import '../../utils/custom_style.dart';
import '../../utils/dimensions.dart';
import '../../utils/strings.dart';
import '../../widgets/buttons/primary_button_widget.dart';
import '../../widgets/input/input_controller.dart';

class SignInScreen extends GetView<HomeController> {
  SignInScreen({Key? key}) : super(key: key);

  // Initialize controllers
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final ValueNotifier<int> userOtpController = ValueNotifier<int>(0);
  final TextEditingController resetpassworController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: Dimensions.defaultPaddingSize),
          child: Center(
            child: ListView(
              shrinkWrap: true,
              physics: const BouncingScrollPhysics(),
              children: [
                Image.asset(
                  "assets/Bmail_Logo_Gif-full.gif",
                  width: MediaQuery.of(context).size.width * .10,
                  height: MediaQuery.of(context).size.width * .40,
                  alignment: Alignment.center,
                ),
                Form(
                  key: controller.loginFormKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField(
                        controller: controller.emailController,
                        hintText: Strings.enterEmail,
                        labelText: Strings.email,
                        keyboardType: TextInputType.emailAddress,
                        icon: Icons.email,
                      ),
                      SizedBox(height: Dimensions.heightSize * 1),
                      _buildTextField(
                        controller: controller.passwordController,
                        hintText: Strings.enterPassword,
                        labelText: Strings.password,
                        obscureText: true,
                        keyboardType: TextInputType.text,
                        icon: Icons.lock,
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
                                color: CustomColor.secondaryColor,
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
                  )
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
    bool obscureText = false,
    required TextInputType keyboardType,
    required IconData icon,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: Dimensions.marginSize * 0.5),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          decoration: InputDecoration(
            prefixIcon: Icon(icon, color: Colors.black54),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius * 1),
            ),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(
              horizontal: Dimensions.defaultPaddingSize,
              vertical: 16.h,
            ),
            hintText: hintText,
            hintStyle: CustomStyle.hintTextStyle.copyWith(color: Colors.black54),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return Strings.pleaseFillOutTheField;
            }
            return null;
          },
        ),
      ],
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
                  Uri.parse('https://petdoctorindia.in/login'),
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
              // SizedBox(height: Dimensions.heightSize * 2),
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
                      Uri.parse('https://petdoctorindia.in/forget'),
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

  // void _sendOtp() {
  //   // Implement OTP sending logic here
  // }

  Widget _donTHaveAccountWidget(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.signUpScreen);
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'NewToxBmailBiz?',
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
                color: CustomColor.secondaryColor, // Assuming CustomColor.secondaryColor is defined
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}