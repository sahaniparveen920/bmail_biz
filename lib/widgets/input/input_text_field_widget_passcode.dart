import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../utils/custom_color.dart';
import '../../utils/custom_style.dart';
import '../../utils/dimensions.dart';
import '../../utils/strings.dart';
import 'input_controller.dart';


class InputTextFieldPassCode extends GetView<HomeController> {

  final String hintText;

  const InputTextFieldPassCode({Key? key, required controller, required this.hintText, keyboardType, readOnly = false}) : super(key: key);

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
          validator: (String? value){
            if(value!.isEmpty){
              return Strings.pleaseFillOutTheField;
            }else{
              return null;
            }
          },
          decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radius * 5),
                borderSide: const BorderSide(
                    color:Colors.black45, width: 1
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radius * 0.5),
                borderSide: const BorderSide(
                    color:Colors.black45, width: 1                ),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radius * 0.5),
                borderSide: const BorderSide(
                    color:Colors.black45, width: 1                ),
              ),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radius * 0.5),
                borderSide: const BorderSide(color: Colors.red, width: 1),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radius * 0.5),
                borderSide: const BorderSide(color: Colors.red, width: 0.5),
              ),
              filled: true,
              fillColor: CustomColor.white.withOpacity(0.03),
              contentPadding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
              hintText: hintText,
              hintStyle: CustomStyle.hintTextStyle
          ),
        ),
      ],
    );
  }
}
