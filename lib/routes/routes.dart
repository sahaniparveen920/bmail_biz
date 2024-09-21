
import 'package:Bmail/view/bottom_navigation/storage/bmail_storage_page.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/routes/get_route.dart';
import '../onboard/onboard_screen.dart';
import '../pop_up_screen/welcome_page.dart';
import '../view/auth/sign_in_screen.dart';
import '../view/auth/sign_up_screen.dart';
import '../view/bottom_navigation/gmail_page/bmail_draft.dart';
import '../view/bottom_navigation/gmail_page/bmail_sent.dart';
import '../view/bottom_navigation/gmail_page/bmail_spam_page.dart';
import '../view/bottom_navigation/compose/compose_page.dart';
import '../view/bottom_navigation/gmail_page/bmail_main_page.dart';
import '../view/splash screen/splash_screen.dart';

class Routes {
  static const String splashScreen = '/splashScreen';
  static const String onBoardScreen = '/onBoardScreen';
  static const String introScreen = '/introScreen';
  static const String signInScreen = '/signInScreen';
  static const String signUpScreen = '/signUpScreen';
  static const String home = '/home';
  static const String bmailmainpage = '/bmailpage';
  static const String bmailsent = '/bmailsent';
  static const String compose = '/composepage';
  static const String bmaildraftpage = '/bmaildraft';
  static const String bmailspampage = '/bmailspampage';
  static const String bmailtrashpage = '/bmailtrashpage';
  static const String welcomePage = '/welcomePage';
  static const String bmailstoragepage = '/bmailstoragepage';

  static var list = [
    GetPage(
      name: splashScreen,
      page: () => SplashScreen(),
    ),
    GetPage(
      name: onBoardScreen,
      page: () => const OnBoardScreen(),
    ),
    GetPage(
      name: signInScreen,
      page: () => SignInScreen(),
    ),
    GetPage(
      name: signUpScreen,
      page: () => SignUpScreen(),
    ),
    GetPage(
      name: bmailmainpage,
      page: () => const BmailMainPage(),
    ),
    GetPage(
      name: bmailsent,
      page: () => const BmailSent(),
    ),
    GetPage(
      name: compose,
      page: () => ComposePage(),
    ),
    GetPage(
      name: bmaildraftpage,
      page: () => BmailDraftPage(),
    ),
    GetPage(
      name: bmailspampage,
      page: () => BmailSpamPage(),
    ),
    GetPage(
      name: welcomePage,
      page: () => WelcomePage(),
    ),
    GetPage(
        name: bmailstoragepage,
        page: () => BmailStoragePage(),
    ),
  ];
}


