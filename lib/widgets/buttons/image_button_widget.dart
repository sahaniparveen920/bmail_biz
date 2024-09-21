import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../utils/dimensions.dart';

class ImageButtonWidget extends StatelessWidget {

  final String title;
  final String imagePath;
  final VoidCallback onPressed;

  const ImageButtonWidget({Key? key, required this.title, required this.imagePath, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: TextButton(
        onPressed: onPressed,
        style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Colors.black),
            side: MaterialStateProperty.all(BorderSide(
                color: Colors.grey.withOpacity(0.5)
            )),
            padding: MaterialStateProperty.all(
                EdgeInsets.symmetric(
                    vertical: 14.h
                )
            ),
            textStyle: MaterialStateProperty.all(
                TextStyle(
                    fontSize: Dimensions.defaultTextSize.sp,
                    fontWeight: FontWeight.w700
                )
            )
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              imagePath,
              width: 16,
            ),
            SizedBox(width: 14.w,),
            Text(
                title
            ),
          ],
        ),
      ),
    );
  }
}
