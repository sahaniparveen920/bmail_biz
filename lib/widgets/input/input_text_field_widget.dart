import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import '../../utils/custom_color.dart';
import '../../utils/custom_style.dart';
import '../../utils/dimensions.dart';
import '../../utils/strings.dart';
import 'input_controller.dart';


class InputTextFieldWidget extends GetView<HomeController> {

  final String hintText;

  const InputTextFieldWidget({Key? key, required controller, required this.hintText, keyboardType, readOnly = false}) : super(key: key);

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
                    color:Colors.black87, width: 5
                ),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radius * 0.5),
                borderSide: const BorderSide(color: Colors.black87, width: 3),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(Dimensions.radius * 0.5),
                borderSide: const BorderSide(color: Colors.black87, width: 3),
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
              contentPadding: EdgeInsets.symmetric(horizontal: Dimensions.defaultPaddingSize * 0.7, vertical: 9.h),
              hintText: hintText,
              hintStyle: CustomStyle.hintTextStyle
          ),
        ),
      ],
    );
  }
}
