import 'package:adv/Features/onboarding/presentation/manager/onboarding_cubit.dart';
import 'package:adv/Features/onboarding/presentation/manager/onboarding_state.dart';
import 'package:adv/core/exports/ui_exports.dart';
import 'package:adv/core/routing/app_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'pages/age_selection_page.dart';
import 'pages/gender_selection_page.dart';
import 'pages/interests_selection_page.dart';
import 'pages/welcome_page.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  late final PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _next() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  Future<void> _finish(BuildContext context) async {
    await context.read<OnboardingCubit>().complete();
    if (!context.mounted) return;
    AppRouter.router.go(AppRouter.kHomeView);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OnboardingCubit, OnboardingState>(
      builder: (context, state) {
        final pages = [
          WelcomePage(onGetStarted: _next),
          GenderSelectionPage(
            selectedGender: state.gender,
            onSelect: context.read<OnboardingCubit>().setGender,
            onContinue: _next,
          ),
          AgeSelectionPage(
            selectedIndex: state.ageIndex,
            onSelect: context.read<OnboardingCubit>().setAgeIndex,
            onContinue: _next,
          ),
          InterestsSelectionPage(
            selectedInterests: state.interests,
            onToggle: context.read<OnboardingCubit>().toggleInterest,
            isLoading: state.isCompleting,
            onFinish:
                state.interests.length == 4 && !state.isCompleting
                    ? () => _finish(context)
                    : null,
          ),
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
