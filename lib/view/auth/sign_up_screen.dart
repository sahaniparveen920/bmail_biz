import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'dart:math';
import 'dart:convert';
import '../../routes/routes.dart';
import '../../utils/custom_color.dart';
import '../../utils/dimensions.dart';
import '../../utils/strings.dart';
import '../../widgets/buttons/primary_button_widget.dart';

class SignUpScreen extends StatefulWidget {
  @override
  _SignUpScreenState createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController mobileController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final otpController = 0.obs;
  final userOtpController = 0.obs;
  bool showOtpFields = false;

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      final response = await http.post(
        Uri.parse('https://petdoctorindia.in/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': nameController.text,
          'email': emailController.text,
          'password': passwordController.text,
          'mobile': mobileController.text,
        }),
      );

      print('Sign Up Response Status: ${response.statusCode}');
      print('Sign Up Response Body: ${response.body}');

      if (response.statusCode == 200) {
        Get.offNamed(Routes.signInScreen);
        Get.snackbar(
          'Success',
          'Account Created successfully.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
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
    }
  }

  Future<void> _sendOtp() async {
    final random = Random();
    final otp = 100000 + random.nextInt(900000); // Generate a 6-digit OTP
    otpController.value = otp;
    print('Generated OTP: $otp'); // Debugging: Print the OTP to console
    final url = Uri.parse(
        'https://i.4sd.in/send-message?api_key=pHtA3oH7QTMs0Eta4oSLxijjkjfoAE&sender=917982856964&number=91${mobileController.text}&message=Your%20OTP%20is%20$otp'
    );

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
      );

      print('Send OTP Response Status: ${response.statusCode}');
      print('Send OTP Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          Get.snackbar(
            'Success',
            'OTP sent successfully.',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );
          setState(() {
            showOtpFields = true;
          });
        } else {
          Get.snackbar(
            'Error',
            'OTP sent successfully: ${responseData['error'] ?? 'Verify OTP'}',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );
        }
      } else {
        Get.snackbar(
          'Error',
          'Failed to send OTP: ${response.statusCode} ${response.reasonPhrase}',
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

  @override
  Widget build(BuildContext context) {
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
                  height: MediaQuery.of(context).size.width * .45,
                  alignment: Alignment.center,
                ),
                // SizedBox(height: Dimensions.heightSize * 5),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildTextField(
                        controller: nameController,
                        hintText: Strings.enterFullName,
                        labelText: Strings.name,
                        keyboardType: TextInputType.name,
                        icon: Icon(Icons.person),
                      ),
                      SizedBox(height: Dimensions.heightSize * 1),
                      _buildTextField(
                        controller: emailController,
                        hintText: Strings.enterEmail,
                        labelText: Strings.email,
                        keyboardType: TextInputType.emailAddress,
                        icon: Icon(Icons.email),
                      ),
                      SizedBox(height: Dimensions.heightSize * 1),
                      _buildTextField(
                        controller: passwordController,
                        hintText: Strings.enterPassword,
                        labelText: Strings.password,
                        obscureText: true,
                        keyboardType: TextInputType.text,
                        icon: Icon(Icons.lock),
                      ),
                      SizedBox(height: Dimensions.heightSize * 1),
                      Row(
                        children: [
                          Expanded(
                            flex: 2,
                            child: _buildTextField(
                              controller: mobileController,
                              hintText: Strings.enterPhoneNumber,
                              labelText: Strings.phone,
                              keyboardType: TextInputType.phone,
                              icon: Icon(Icons.phone),
                            ),
                          ),
                          SizedBox(width: Dimensions.marginSize),
                          Expanded(
                            flex: 1,
                            child: ElevatedButton(
                              onPressed: () {
                                _sendOtp();
                                showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: Text("Enter OTP"),
                                      content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          OtpTextField(
                                            numberOfFields: 6,
                                            borderColor: Colors.grey, // Grey border color
                                            focusedBorderColor: Colors.grey, // Grey border color when focused
                                            showFieldAsBox: true,
                                            borderWidth: 0.20,
                                            fieldWidth: 35,
                                            fillColor: Colors.transparent,
                                            textStyle: TextStyle(color: Colors.grey), // Grey text color
                                            onCodeChanged: (String code) {},
                                            onSubmit: (String verificationCode) {
                                              print(verificationCode);
                                              userOtpController.value = int.tryParse(verificationCode)!;
                                            },
                                          ),
                                          SizedBox(height: 10),
                                          ElevatedButton(
                                            onPressed: () {
                                              if (otpController.value == userOtpController.value) {
                                                Get.snackbar(
                                                  "Success",
                                                  "OTP verified successfully",
                                                  snackPosition: SnackPosition.BOTTOM,
                                                  backgroundColor: Colors.green,
                                                  colorText: Colors.white,
                                                  duration: const Duration(seconds: 3),
                                                );
                                                Navigator.pop(context); // Close the OTP dialog
                                                _sendOtp(); // Proceed with signup
                                              } else {
                                                Get.snackbar(
                                                  "Error",
                                                  "Invalid OTP",
                                                  snackPosition: SnackPosition.BOTTOM,
                                                  backgroundColor: Colors.redAccent,
                                                  colorText: Colors.white,
                                                  duration: const Duration(seconds: 3),
                                                );
                                              }
                                            },
                                            child: Text("Verify"),
                                          ),
                                        ],
                                      ),
                                    );
                                  },
                                );
                              },

                              child: Text("Send OTP",style: TextStyle(
                                color: CustomColor.white,
                              ),),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: CustomColor.secondaryColor,
                                padding: EdgeInsets.symmetric(
                                    vertical: Dimensions.heightSize * 1.4),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: Dimensions.heightSize * 3),
                    ],
                  ),
                ),
                PrimaryButtonWidget(
                  title: Strings.signUp,
                  onPressed: _signUp,
                ),
                SizedBox(height: Dimensions.heightSize * 3),
                Row(
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
                        Get.toNamed(Routes.signInScreen); // Navigate to sign-in screen
                      },
                      child: Text(
                        'Signin',
                        style: TextStyle(
                          fontSize: 13,
                          color: CustomColor.secondaryColor, // Assuming CustomColor.secondaryColor is defined
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
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
    TextInputType keyboardType = TextInputType.text,
    Icon? icon,
    bool obscureText = false,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: (value) {
        if (value!.isEmpty) {
          return '$labelText cannot be empty';
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        prefixIcon: icon,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}



