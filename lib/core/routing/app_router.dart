import 'package:adv/Features/Home/presentation/views/home_view.dart';
import 'package:adv/Features/onboarding/presentation/manager/onboarding_cubit.dart';
import 'package:adv/Features/onboarding/presentation/views/onboarding_screen.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Features/Home/presentation/views/book_details_view.dart';
import '../../Features/search/views/search_view.dart';
import '../../Features/splash/presentation/views/splash_view.dart';
import '../services/setup_service_locator.dart';
import '../../Features/onboarding/domain/use_cases/complete_onboarding_use_case.dart';

abstract class AppRouter {
  static const kHomeView = '/homeView';
  static const kBookDetailsView = '/bookDetailsView';
  static const kSearchView = '/searchView';
  static const kOnboardingView = '/onboarding';

  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashView()),
      GoRoute(
        path: kOnboardingView,
        builder: (context, state) {
          return BlocProvider(
            create:
                (_) => OnboardingCubit(getIt.get<CompleteOnboardingUseCase>()),
            child: const OnboardingScreen(),
          );
        },
      ),
      GoRoute(path: '/homeView', builder: (context, state) => const HomeView()),
      GoRoute(
        path: '/bookDetailsView',
        builder: (context, state) => const BookDetailsView(),
      ),
      GoRoute(
        path: '/searchView',
        builder: (context, state) => const SearchView(),
      ),
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
