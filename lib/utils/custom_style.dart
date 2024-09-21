import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'custom_color.dart';
import 'dimensions.dart';

class CustomStyle {
  static var textStyle = TextStyle(
    color: Colors.black,
    fontSize: Dimensions.largeTextSize,
    fontWeight: FontWeight.w600,
  );

  static var updateTextStyle = TextStyle(
    color: Colors.white,
    fontSize: Dimensions.largeTextSize,
    fontWeight: FontWeight.bold,
  );

  static var hintTextStyle = TextStyle(
    fontSize: Dimensions.extraSmallTextSize,
    fontWeight: FontWeight.normal,
    color: Colors.black.withOpacity(0.4),
  );

  static var hintTextStyleForSearch = TextStyle(
    fontSize: Dimensions.defaultTextSize,
    fontWeight: FontWeight.normal,
    color: Colors.black.withOpacity(0.4),
  );

  static var listStyle = TextStyle(
    color: Colors.white,
    fontSize: Dimensions.defaultTextSize,
  );

  static var defaultStyle = TextStyle(
    color: Colors.white,
    fontSize: Dimensions.largeTextSize,
  );

  // Use a different name for this hintTextStyle
  static TextStyle headerHintTextStyle = GoogleFonts.roboto(
    fontSize: 14.sp,
    color: CustomColor.darkGrey,
  );

  static TextStyle headerTextStyle = GoogleFonts.roboto(
    fontSize: 24.sp,
    fontWeight: FontWeight.bold,
    color: CustomColor.primaryColor,
  );

  static TextStyle labelTextStyle = GoogleFonts.roboto(
    fontSize: 16.sp,
    fontWeight: FontWeight.bold,
    color: CustomColor.primaryColor,
  );

  static TextStyle linkTextStyle = GoogleFonts.roboto(
    fontSize: Dimensions.defaultTextSize,
    fontWeight: FontWeight.bold,
    color: CustomColor.secondaryColor,
    decoration: TextDecoration.underline,
  );

}
