import 'dart:async'; // Import for Timer
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_otp_text_field/flutter_otp_text_field.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
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

  // List of colors for background
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
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Start the timer to change colors
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      // setState(() {
      //   // Update the color index to show the next color
      // //  colorIndex = (colorIndex + 1) % colors.length;
      // });
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the screen is disposed
    super.dispose();
  }

  Future<void> _signUp() async {
    if (_formKey.currentState!.validate()) {
      // Append "@bmail.biz" to the email entered by the user
      final emailWithDomain = emailController.text.trim().contains('@bmail.biz')
          ? emailController.text.trim()
          : '${emailController.text.trim()}@bmail.biz';

      final response = await http.post(
        Uri.parse('https://apiv2.bmail.biz/signup'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': nameController.text,
          'email': emailWithDomain,
          'password': passwordController.text,
          'mobile': mobileController.text,
        }),
      );

      print('Sign Up Response Status: ${response.statusCode}');
      print('Sign Up Response Body: ${response.body}');

      if (response.statusCode == 200) {
        // Initiate the phone call after successful signup
        print(mobileController.text);
        final callResponse = await http.get(
          Uri.parse('http://142.93.208.82/API/flash_callapi.php?auth=D!2700Osgh65sRnM&voiceid=15187&msisdn=${mobileController.text}&type=1&retry=1'),
        );

        print('Call Response Status: ${callResponse.statusCode}');
        print('Call Response Body: ${callResponse.body}');

        Get.offAllNamed(Routes.signInScreen);
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

    // First API to send OTP via WhatsApp
    final whatsappUrl = Uri.parse(
        'https://i.4sd.in/send-message?api_key=pHtA3oH7QTMs0Eta4oSLxijjkjfoAE&sender=917982856964&number=91${mobileController.text}&message=Your%20OTP%20is%20$otp');

    // Second API to send OTP via SMS
    final smsUrl = Uri.parse(
        'https://sms.seoagedigital.com/API/sms-api.php?auth=D!~9968c9Wy2IUNrs%20&msisdn=${mobileController.text}&senderid=BCLOUW&message=Your%20verification%20code%20is$otp%20Please%20enter%20this%20code%20to%20verify%20your%20account%20This%20code%20will%20expire%20in%2010%20minutes%20If%20you%20did%20not%20request%20this%20code%20please%20ignore%20this%20message%20Thank%20you%20BCLOUD%C2%A0WEB%C2%A0SERVICES');

    try {
      // Send OTP via WhatsApp
      print('Sending OTP via WhatsApp...');
      print('WhatsApp URL: $whatsappUrl');
      final whatsappResponse = await http.post(
        whatsappUrl,
        headers: {'Content-Type': 'application/json'},
      );

      final appResponse = await http.get(
        smsUrl,
        headers: {'Content-Type': 'application/json'},
      );


      print('Send OTP WhatsApp Response Status: ${whatsappResponse.statusCode}');
      print('Send OTP WhatsApp Response Body: ${appResponse.body}');

      if (whatsappResponse.statusCode == 200) {
        final whatsappResponseData = jsonDecode(whatsappResponse.body);
        // Check the status in the response data
        if (whatsappResponseData['status'] == true) {
          print('OTP sent via WhatsApp successfully.');
          // Proceed to send OTP via SMS
          print('Sending OTP via SMS...');
          print('SMS URL: $smsUrl');
          final smsResponse = await http.post(
            smsUrl,
            headers: {'Content-Type': 'application/json'},
          );

          print('Send OTP SMS Response Status: ${smsResponse.statusCode}');
          print('Send OTP SMS Response Body: ${smsResponse.body}');

          if (smsResponse.statusCode == 200) {
            final smsResponseData = jsonDecode(smsResponse.body);
            if (smsResponseData['status'] == true) {
              Get.snackbar(
                'Success',
                'OTP sent successfully via WhatsApp and SMS.',
                snackPosition: SnackPosition.BOTTOM,
                backgroundColor: Colors.green,
                colorText: Colors.white,
                duration: const Duration(seconds: 3),
              );
              setState(() {
                showOtpFields = true; // Show OTP fields after sending OTP
              });
            } else {

            }
          } else {

          }
        } else {
          Get.snackbar(
            'Error',
            'Failed to send OTP via WhatsApp: ${whatsappResponseData['message'] ?? 'Unknown error'}',
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 3),
          );
        }
      } else {
        Get.snackbar(
          'Error',
          'Failed to send OTP via WhatsApp: ${whatsappResponse.statusCode} ${whatsappResponse.reasonPhrase}',
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
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: SafeArea(
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
                      color: Colors.grey.withOpacity(0.2), // Semi-transparent background
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
                          "SIGN UP",
                          style: TextStyle(
                            color: Colors.deepOrange.shade400,
                            fontSize: 36,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: Dimensions.heightSize * 2),
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
                              _buildEmailTextField(
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
                                                mainAxisSize: MainAxisSize.min, // Allows the column to be as small as possible
                                                crossAxisAlignment: CrossAxisAlignment.center,
                                                children: [
                                                  OtpTextField(
                                                    numberOfFields: 6,
                                                    fieldWidth: 30, // Adjust the width of each field as necessary
                                                    borderColor: CustomColor.primaryColor,
                                                    focusedBorderColor: CustomColor.secondaryColor, // Border color when focused
                                                    showFieldAsBox: true, // This will show the input fields as boxes
                                                    textStyle: TextStyle(color: Colors.black), // Set the text color
                                                    onCodeChanged: (String code) {
                                                      // Handle validation or checks here if necessary
                                                    },
                                                    onSubmit: (String verificationCode) {
                                                      userOtpController.value = int.parse(verificationCode);
                                                    },
                                                  ),

                                                  SizedBox(height: 20),
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
                                                        _signUp(); // Proceed with signup
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
                                      style: ElevatedButton.styleFrom(
                                        padding: EdgeInsets.symmetric(vertical: Dimensions.heightSize * 1.4),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(Dimensions.radius),
                                        ),
                                      ),
                                      child: Text(
                                        'Send OTP',
                                        style: TextStyle(fontSize: Dimensions.largeTextSize),
                                      ),
                                    ),
                                  ),

                                ],
                              ),
                              SizedBox(height: Dimensions.heightSize * 2),
                              PrimaryButtonWidget(
                                title: Strings.signUp,
                                onPressed: _signUp,
                              ),
                              SizedBox(height: Dimensions.heightSize * 2),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Already have an account?",
                                    style: TextStyle(fontSize: Dimensions.defaultTextSize),
                                  ),
                                  SizedBox(width: Dimensions.heightSize * 1),
                                  GestureDetector(
                                    onTap: () {
                                      Get.toNamed(Routes.signInScreen);
                                    },
                                    child: Text(
                                      "Sign In",
                                      style: TextStyle(
                                        fontSize: Dimensions.defaultTextSize,
                                        color: CustomColor.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              )
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
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hintText,
    required String labelText,
    bool obscureText = false,
    required TextInputType keyboardType,
    required Icon icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20), // Set the border radius
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // Shadow color
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // Shadow position
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          prefixIcon: icon,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20), // Match the container's radius
            borderSide: BorderSide.none, // Remove the border line
          ),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter $labelText';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildEmailTextField({
    required TextEditingController controller,
    required String hintText,
    required String labelText,
    required TextInputType keyboardType,
    required Icon icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20), // Set the border radius
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5), // Shadow color
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3), // Shadow position
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          hintText: hintText,
          labelText: labelText,
          prefixIcon: icon,
          suffixText: '@bmail.biz', // Display '@bmail.biz' at the end of the text field
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20), // Match the container's radius
            borderSide: BorderSide.none, // Remove the border line
          ),
        ),
        validator: (value) {
          if (value!.isEmpty) {
            return 'Please enter $labelText';
          }
          if (!GetUtils.isEmail(value.trim() + "@bmail.biz")) {
            return 'Please enter a valid email address';
          }
          return null;
        },
      ),
    );
  }
}


