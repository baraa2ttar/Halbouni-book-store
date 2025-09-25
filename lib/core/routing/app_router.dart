import 'package:adv/core/exports/ui_exports.dart';
import 'package:adv/view/onboarding/screens/onboarding_screen.dart';
import 'package:adv/view/splash/screens/widgets/splash_screen.dart';
import 'package:adv/view/auth/screens/signup_screen.dart';

final List<GetPage> appPages = [
  GetPage(name: Routes.onboarding, page: () => OnboardingScreen()),
  GetPage(name: Routes.splash, page: () => SplashScreen()),
  GetPage(name: Routes.signUp, page: () => SignUpScreen()),
  //GetPage(name: Routes.home, page: () => const HomeMainScreen()),
  // GetPage(name: Routes.login, page: () =>  LoginScreen()),
];
