import 'package:adv/core/exports/ui_exports.dart';
import 'package:adv/view/auth/screens/signin_screen.dart';
import 'package:adv/view/onboarding/screens/onboarding_screen.dart';

import 'package:adv/view/auth/screens/signup_screen.dart';

import '../../Features/splash/presentation/views/splash_view.dart';

final List<GetPage> appPages = [
  GetPage(name: Routes.onboarding, page: () => OnboardingScreen()),
  GetPage(name: Routes.splash, page: () => SplashView()),
  GetPage(name: Routes.signUp, page: () => SignUpScreen()),
  GetPage(name: Routes.signIn, page: () => SignInScreen()),
  //GetPage(name: Routes.home, page: () => const HomeMainScreen()),
  // GetPage(name: Routes.login, page: () =>  LoginScreen()),
];
