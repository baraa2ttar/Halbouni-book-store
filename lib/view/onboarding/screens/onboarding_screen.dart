import 'package:adv/core/exports/ui_exports.dart';
import 'package:adv/view/onboarding/controller/onboarding_controller.dart';
import 'package:adv/view/onboarding/screens/pages/age_selection_page.dart';
import 'package:adv/view/onboarding/screens/pages/gender_selection_page.dart';
import 'package:adv/view/onboarding/screens/pages/interests_selection_page.dart';
import 'package:adv/view/onboarding/screens/pages/welcome_page.dart';
import 'package:adv/view/onboarding/screens/widgets/dots.dart';
import 'package:adv/view/onboarding/screens/widgets/card_googl.dart';
import 'package:flutter/material.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<OnboardingController>(
      init: Get.put(OnboardingController()),
      builder: (controller) {
        final List<Widget> pages = [
          WelcomePage(controller: controller),
          GenderSelectionPage(controller: controller),
          AgeSelectionPage(controller: controller),
          InterestsSelectionPage(controller: controller),
        ];

        return SizedBox(
          height: context.h(5),
          child: PageView.builder(
            controller: controller.pageController,
            itemCount: pages.length,
            itemBuilder: (_, index) => pages[index],
          ),
        );
      },
    );
  }
}
