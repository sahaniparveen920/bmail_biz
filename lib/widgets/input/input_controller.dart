import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeController extends GetxController {
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  late TextEditingController emailController, passwordController, meetingIdController;
  late TextEditingController nameController, usernameController, passwordConfirmationController;
  String mettingIdController = 'https://bharatconnect.biz/m/PNxJ41';


  var email = '';
  var password = '';
  var name = '';
  var username = '';
  var passwordConfirmation = '';
  var readOnly = false;
  late final TextInputType? keyboardType;
  var emailHint = 'Enter your email';
  var meetingId = 'Enter meeting Id';

  @override
  void onInit() {
    super.onInit();
    emailController = TextEditingController();
    passwordController = TextEditingController();
    nameController = TextEditingController();
    usernameController = TextEditingController();
    passwordConfirmationController = TextEditingController();
    meetingIdController = TextEditingController();
    keyboardType = TextInputType.text;
  }

  @override
  void onClose() {
    emailController.clear();
    passwordController.clear();
    nameController.clear();
    usernameController.clear();
    passwordConfirmationController.clear();
    meetingIdController.clear();
  }

  String? validateEmail(String value) {
    if (!GetUtils.isEmail(value)) {
      return "Provide valid Email";
    }
    return null;
  }

  String? validatePassword(String value) {
    if (value.length < 6) {
      return "Password must be of 6 characters";
    }
    return null;
  }

  void checkLogin() {
    final isValid = loginFormKey.currentState!.validate();
    if (!isValid) {
      return;
    }
    loginFormKey.currentState!.save();
  }
}
