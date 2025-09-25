import 'package:flutter/material.dart';
import 'package:adv/core/exports/ui_exports.dart';
import 'package:adv/view/onboarding/controller/onboarding_controller.dart';
import 'package:adv/view/onboarding/screens/widgets/dots.dart';
import 'package:adv/view/onboarding/screens/widgets/card_googl.dart';

class WelcomePage extends StatelessWidget {
  final OnboardingController controller;

  const WelcomePage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Image.asset(
            AppAssets.books_background,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),

          // Gradient overlay for fading effect
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  Colors.transparent,
                  Colors.transparent,
                  Colors.white,
                  Colors.white,
                  Colors.white,
                ],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 470),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome to ',
                        style: TextStyle(
                          fontSize: context.fs(24),
                          color: Colors.black,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Text(
                        'Halbouni',
                        style: TextStyle(
                          fontSize: context.fs(24),
                          color: AppColor.primaryColor,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: context.h(15)),
                  Text(
                    "The first online Book store application in syria",
                    style: TextStyle(color: AppColor.titleColor),
                  ),
                  SizedBox(height: context.h(20)),
                  Dots(),
                  SizedBox(height: 55),

                  CardGoogle(
                    onTap: controller.navigateToNextPage,
                    label: "Get started",
                    backGroundColor: AppColor.primaryColor,
                  ),
                  SizedBox(height: 5),
                  CardGoogle(
                    imagePath: AppAssets.google,
                    label: "continue with google",
                    backGroundColor: Colors.transparent,
                  ),
                  SizedBox(height: 10),

                  Text(
                    "I alredy have an Account",
                    style: TextStyle(color: AppColor.primaryColor),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
