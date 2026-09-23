import 'package:adv/Features/auth/presentation/manager/auth_cubit/auth_cubit.dart';
import 'package:adv/Features/auth/presentation/views/auth_sign_in_view.dart';
import 'package:adv/Features/auth/presentation/views/auth_sign_up_view.dart';
import 'package:adv/Features/Home/domain/entities/product_entity.dart';
import 'package:adv/Features/Home/presentation/views/home_view.dart';
import 'package:adv/Features/cart/presentation/views/cart_view.dart';
import 'package:adv/Features/cart/presentation/views/checkout_view.dart';
import 'package:adv/Features/onboarding/presentation/manager/onboarding_cubit.dart';
import 'package:adv/Features/onboarding/presentation/views/onboarding_screen.dart';
import 'package:adv/Features/orders/presentation/manager/checkout_cubit/checkout_cubit.dart';
import 'package:adv/Features/profile/presentation/manager/profile_cubit/profile_cubit.dart';
import 'package:adv/Features/profile/presentation/views/profile_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../Features/Home/presentation/views/book_details_view.dart';
import '../../Features/search/presentation/views/search_view.dart';
import '../../Features/splash/presentation/views/splash_view.dart';
import '../../Features/onboarding/domain/repos/onboarding_repo.dart';
import '../services/setup_service_locator.dart';
import '../../Features/onboarding/domain/use_cases/complete_onboarding_use_case.dart';

abstract class AppRouter {
  static const kHomeView = '/homeView';
  static const kBookDetailsView = '/bookDetailsView';
  static const kSearchView = '/searchView';
  static const kCartView = '/cartView';
  static const kCheckoutView = '/checkout';
  static const kProfileView = '/profile';
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
                )..restoreDraft(),
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
        path: kCartView,
        builder: (context, state) => const CartView(),
      ),
      GoRoute(
        path: kCheckoutView,
        builder: (context, state) {
          return BlocProvider(
            create: (_) => getIt.get<CheckoutCubit>(),
            child: const CheckoutView(),
          );
        },
      ),
      GoRoute(
        path: kProfileView,
        builder: (context, state) {
          return BlocProvider(
            create: (_) => getIt.get<ProfileCubit>()..loadProfile(),
            child: const ProfileView(),
          );
        },
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

