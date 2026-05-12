import 'package:adv/Features/Auth/presentation/manager/auth_cubit/auth_cubit.dart';
import 'package:adv/Features/Auth/presentation/views/auth_sign_in_view.dart';
import 'package:adv/Features/Auth/presentation/views/auth_sign_up_view.dart';
import 'package:adv/Features/Home/domain/entities/product_entity.dart';
import 'package:adv/Features/Home/presentation/views/home_view.dart';
import 'package:adv/Features/onboarding/presentation/manager/onboarding_cubit.dart';
import 'package:adv/Features/onboarding/presentation/views/onboarding_screen.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../Features/Home/presentation/views/book_details_view.dart';
import '../../Features/search/views/search_view.dart';
import '../../Features/splash/presentation/views/splash_view.dart';
import '../../Features/onboarding/domain/repos/onboarding_repo.dart';
import '../services/setup_service_locator.dart';
import '../../Features/onboarding/domain/use_cases/complete_onboarding_use_case.dart';

abstract class AppRouter {
  static const kHomeView = '/homeView';
  static const kBookDetailsView = '/bookDetailsView';
  static const kSearchView = '/searchView';
  static const kOnboardingView = '/onboarding';
  static const kAuthSignIn = '/auth/sign-in';
  static const kAuthSignUp = '/auth/sign-up';

  /// Last index in [OnboardingScreen] `PageView` (interests / profile prep step).
  static const int onboardingLastPageIndex = 3;

  /// Query key: `?startPage=0` … `onboardingLastPageIndex` opens that onboarding step first.
  static const String onboardingStartPageQuery = 'startPage';

  static String onboardingPath({int startPage = 0}) {
    final clamped = startPage.clamp(0, onboardingLastPageIndex);
    return '$kOnboardingView?$onboardingStartPageQuery=$clamped';
  }

  static int parseOnboardingStartPage(GoRouterState state) {
    final raw = state.uri.queryParameters[onboardingStartPageQuery];
    final parsed = int.tryParse(raw ?? '');
    if (parsed == null) return 0;
    return parsed.clamp(0, onboardingLastPageIndex);
  }

  static final GoRouter router = GoRouter(
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashView()),
      GoRoute(
        path: kOnboardingView,
        builder: (context, state) {
          final startPage = parseOnboardingStartPage(state);
          return BlocProvider(
            create:
                (_) => OnboardingCubit(
                  getIt.get<CompleteOnboardingUseCase>(),
                  getIt.get<OnboardingRepo>(),
                ),
            child: OnboardingScreen(initialPageIndex: startPage),
          );
        },
      ),
      GoRoute(path: '/homeView', builder: (context, state) => const HomeView()),
      GoRoute(
        path: '/bookDetailsView/:id',
        builder: (context, state) {
          final id = state.pathParameters['id']!;
          final product = state.extra as ProductEntity?;
          return BookDetailsView(productId: id, productEntity: product);
        },
      ),
      GoRoute(
        path: '/searchView',
        builder: (context, state) => const SearchView(),
      ),
      GoRoute(
        path: kAuthSignIn,
        builder: (context, state) {
          return BlocProvider(
            create: (_) => getIt.get<AuthCubit>(),
            child: const AuthSignInView(),
          );
        },
      ),
      GoRoute(
        path: kAuthSignUp,
        builder: (context, state) {
          return BlocProvider(
            create: (_) => getIt.get<AuthCubit>(),
            child: const AuthSignUpView(),
          );
        },
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
