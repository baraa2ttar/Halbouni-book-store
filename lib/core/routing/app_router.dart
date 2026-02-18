import 'package:adv/Features/Home/presentation/views/home_view.dart';
import 'package:go_router/go_router.dart';

import '../../Features/Home/presentation/views/book_details_view.dart';
import '../../Features/splash/presentation/views/splash_view.dart';
import '../exports/main_exports.dart';

abstract class AppRouter {
  static const kHomeView = '/homeView';
  static const kBookDetailsView = '/bookDetailsView';
  static const kSearchView = '/searchView';

  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashView()),
      GoRoute(path: '/homeView', builder: (context, state) => const HomeView()),
      GoRoute(path: '/bookDetailsView', builder: (context, state) => const BookDetailsView()),
    ],
  );
}




// final List<GetPage> appPages = [
//   GetPage(name: Routes.onboarding, page: () => OnboardingScreen()),
//   GetPage(name: Routes.splash, page: () => SplashView()),
//   // GetPage(name: Routes.signUp, page: () => SignUpScreen()),
//   // GetPage(name: Routes.signIn, page: () => SignInScreen()),
//   //GetPage(name: Routes.home, page: () => const HomeMainScreen()),
//   // GetPage(name: Routes.login, page: () =>  LoginScreen()),
// ];
