import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../utils/custom_color.dart';
import '../../utils/custom_style.dart';
import '../../utils/strings.dart';
import 'input_controller.dart';

class InputTextFieldWidgetSearch extends GetView<HomeController> {
  final String hintText;

  const InputTextFieldWidgetSearch(
      {Key? key,
      required controller,
      required this.hintText,
      keyboardType,
      readOnly = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    return Column(
      children: [
        TextFormField(
          readOnly: controller.readOnly,
          style: CustomStyle.textStyle,
          controller: controller.emailController,
          keyboardType: controller.keyboardType,
          validator: (String? value) {
            if (value!.isEmpty) {
              return Strings.pleaseFillOutTheField;
            } else {
              return null;
            }
          },
          decoration: InputDecoration(
              suffixIcon: const Icon(
                Icons.search,
                color: Colors.black45,
              ),
              border: InputBorder.none,
              filled: true,
              fillColor: CustomColor.white,
              contentPadding:
                  EdgeInsets.symmetric(horizontal: 12.w, vertical: 12.h),
              hintText: hintText,
              hintStyle: CustomStyle.hintTextStyle),
        ),
      ],
    );
  }
}
