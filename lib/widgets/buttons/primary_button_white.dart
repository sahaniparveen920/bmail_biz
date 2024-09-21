import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/custom_color.dart';
import '../../utils/dimensions.dart';


class PrimaryButtonWidgetWhite extends StatelessWidget {
  final String title;
  final VoidCallback onPressed;

  const PrimaryButtonWidgetWhite(
      {Key? key, required this.title, required this.onPressed })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(CustomColor.secondaryColor),
            padding: MaterialStateProperty.all(
              EdgeInsets.symmetric(vertical: 10.h),
            ),
            textStyle: MaterialStateProperty.all(TextStyle(
                fontSize: Dimensions.defaultTextSize,
                fontWeight: FontWeight.bold)),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(

                  borderRadius: BorderRadius.circular(5.0,),
                  side:  const BorderSide(color: CustomColor.secondaryColor)),
            )),
        child: Text(title),
      ),
    );
  }
}
