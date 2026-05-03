import 'package:adv/core/exports/ui_exports.dart';

import '../widgets/card_googl.dart';
import '../widgets/dots.dart';

class WelcomePage extends StatelessWidget {
  final VoidCallback onGetStarted;

  const WelcomePage({super.key, required this.onGetStarted});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            AppAssets.books_background,
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          Container(
            decoration: const BoxDecoration(
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
                  const SizedBox(height: 470),
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
                  const Dots(),
                  const SizedBox(height: 55),
                  CardGoogle(
                    onTap: onGetStarted,
                    label: "Get started",
                    backGroundColor: AppColor.primaryColor,
                  ),
                  const SizedBox(height: 5),
                  CardGoogle(
                    imagePath: AppAssets.google,
                    label: "continue with google",
                    backGroundColor: Colors.transparent,
                  ),
                  const SizedBox(height: 10),
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
