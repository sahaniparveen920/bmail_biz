import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../utils/custom_color.dart';
import '../../utils/custom_style.dart';
import '../../utils/dimensions.dart';
import '../../utils/strings.dart';

class InputPasswordWidget extends StatefulWidget {

  final TextEditingController controller;
  final String hintText;
  final TextInputType? keyboardType;

  const InputPasswordWidget({Key? key, required this.controller, required this.hintText, this.keyboardType}) : super(key: key);

  @override
  State<InputPasswordWidget> createState() => _InputPasswordWidgetState();
}

class _InputPasswordWidgetState extends State<InputPasswordWidget> {

  bool isVisibility = true;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextFormField(
          readOnly: false,
          style: CustomStyle.textStyle,
          controller: widget.controller,
          keyboardType: widget.keyboardType,
          validator: (String? value){
            if(value!.isEmpty){
              return Strings.pleaseFillOutTheField;
            }else{
              return null;
            }
          },
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius * 0.5),
              borderSide: const BorderSide(
                  color:Colors.black54, width: 0
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius * 0.5),
              borderSide: const BorderSide(color: CustomColor.black100, width: 3),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius * 0.5),
              borderSide: const BorderSide(color: Colors.black87, width: 3),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius * 0.5),
              borderSide: const BorderSide(color: Colors.red, width: 0.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(Dimensions.radius * 0.5),
              borderSide: const BorderSide(color: Colors.red, width: 0.5),
            ),
            filled: true,
            fillColor: CustomColor.white.withOpacity(0.03),
            contentPadding: EdgeInsets.symmetric(horizontal: Dimensions.defaultPaddingSize * 0.7, vertical: 9.h),
            hintText: widget.hintText,
            hintStyle: CustomStyle.hintTextStyle,
            suffixIcon: IconButton(
              icon: Icon(
                isVisibility ? Icons.visibility_off : Icons.visibility,
              ),
              color: CustomColor.black100,
              onPressed: () {
                setState(() {
                  isVisibility = !isVisibility;
                });
              },
            ),
          ),
          obscureText: isVisibility,
        ),

      ],
    );
  }
}



