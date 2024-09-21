import 'package:Bmail/routes/routes.dart';
import 'package:Bmail/utils/custom_color.dart';
import 'package:Bmail/utils/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:get/get.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(414, 896),
        builder: (_, child) => GetMaterialApp(
          title: Strings.appName,
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
              primaryColor: CustomColor.primaryColor,
              textTheme:
              GoogleFonts.robotoTextTheme(Theme.of(context).textTheme),
              appBarTheme:
              const AppBarTheme(color: CustomColor.primaryColor)),
          navigatorKey: Get.key,
          initialRoute: Routes.splashScreen,
          getPages: Routes.list,
        ));
  }
}
