import 'package:adv/Features/onboarding/presentation/manager/onboarding_cubit.dart';
import 'package:adv/Features/onboarding/presentation/manager/onboarding_state.dart';
import 'package:adv/core/exports/ui_exports.dart';
import 'package:adv/core/routing/app_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'pages/age_selection_page.dart';
import 'pages/gender_selection_page.dart';
import 'pages/interests_selection_page.dart';
import 'pages/welcome_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key, this.initialPageIndex = 0});

  /// `PageView` index: 0 welcome, 1 gender, 2 age, 3 interests (see [AppRouter.onboardingLastPageIndex]).
  final int initialPageIndex;

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    final start = widget.initialPageIndex.clamp(
      0,
      AppRouter.onboardingLastPageIndex,
    );
    _pageController = PageController(initialPage: start);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<OnboardingCubit>().setPageIndex(start);
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _goToPage(int index) {
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _next() {
    _goToPage((_pageController.page?.round() ?? widget.initialPageIndex) + 1);
  }

  void _continueAfterGender(OnboardingState state) {
    if (state.isRecovery) {
      if (state.recoveryNeedsAge) {
        _goToPage(2);
      } else if (state.recoveryNeedsInterests) {
        _goToPage(3);
      } else {
        context.read<OnboardingCubit>().submitInterests();
      }
      return;
    }
    _next();
  }

  void _continueAfterAge(OnboardingState state) {
    if (state.isRecovery) {
      if (state.recoveryNeedsInterests) {
        _goToPage(3);
      } else {
        context.read<OnboardingCubit>().submitInterests();
      }
      return;
    }
    _next();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<OnboardingCubit, OnboardingState>(
      listenWhen: (previous, current) =>
          previous.submitStatus != current.submitStatus,
      listener: (context, state) {
        if (state.submitStatus == OnboardingSubmitStatus.failure &&
            state.submitErrorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.submitErrorMessage!)),
          );
        }
        if (state.submitStatus == OnboardingSubmitStatus.success) {
          context.go(
            state.isRecovery ? AppRouter.kProfileView : AppRouter.kHomeView,
          );
        }
        if (state.submitStatus == OnboardingSubmitStatus.needsAuth) {
          context.push(AppRouter.signUpToCompleteOnboardingPath());
        }
      },
      builder: (context, state) {
        if (state.isRecovery && state.isHydrating) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }
        if (state.isRecovery &&
            !state.profileHydrated &&
            state.hydrateErrorMessage != null) {
          return Scaffold(
            appBar: AppBar(
              title: const Text('Complete profile'),
              backgroundColor: Colors.white,
              foregroundColor: AppColor.titleColor,
              elevation: 0,
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      state.hydrateErrorMessage!,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    FilledButton(
                      onPressed: () =>
                          context.read<OnboardingCubit>().hydrateFromProfile(),
                      style: FilledButton.styleFrom(
                        backgroundColor: AppColor.primaryColor,
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          );
        }

        final pages = [
          WelcomePage(onGetStarted: _next),
          GenderSelectionPage(
            selectedGender: state.gender,
            onSelect: context.read<OnboardingCubit>().setGender,
            onContinue: () => _continueAfterGender(state),
          ),
          AgeSelectionPage(
            selectedIndex: state.ageIndex,
            onSelect: context.read<OnboardingCubit>().setAgeIndex,
            onContinue: () => _continueAfterAge(state),
          ),
          const InterestsSelectionPage(),
        ];

        return PageView.builder(
          controller: _pageController,
          physics: const NeverScrollableScrollPhysics(),
          onPageChanged: context.read<OnboardingCubit>().setPageIndex,
          itemCount: pages.length,
          itemBuilder: (_, index) => pages[index],
        );
      },
    );
  }
}
