import 'package:adv/core/exports/ui_exports.dart';
import 'package:adv/core/routing/app_router.dart';
import 'package:go_router/go_router.dart';

import '../widgets/card_email.dart';
import '../widgets/card_googl.dart';
import '../widgets/dots.dart';

class WelcomeContent extends StatelessWidget {
  const WelcomeContent({
    super.key,
    required this.onGetStarted,
    this.compact = false,
  });

  final VoidCallback onGetStarted;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final titleSize = context.fs(compact ? 22 : 24);
    final spacing = context.responsiveValue(
      mobile: compact ? 10.0 : 12.0,
      tablet: 14.0,
      laptop: 16.0,
    );

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Welcome to ',
              style: TextStyle(
                fontSize: titleSize,
                color: Colors.black,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              'Halbouni',
              style: TextStyle(
                fontSize: titleSize,
                color: AppColor.primaryColor,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        SizedBox(height: spacing),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.horizontalPadding),
          child: Text(
            'The first online Book store application in syria',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: AppColor.titleColor,
              fontSize: context.fs(compact ? 14 : 15),
            ),
          ),
        ),
        SizedBox(height: spacing),
        const Dots(),
        SizedBox(height: context.responsiveValue(mobile: 24, tablet: 32, laptop: 36)),
        CardGoogle(
          onTap: onGetStarted,
          label: 'Get started',
          backGroundColor: AppColor.primaryColor,
        ),
        SizedBox(height: compact ? 4 : 6),
        CardGoogle(
          imagePath: AppAssets.google,
          label: 'continue with google',
          backGroundColor: Colors.transparent,
        ),
        SizedBox(height: compact ? 8 : 10),
        CardEmail(
          onTap: () => context.push(AppRouter.kAuthSignUp),
          label: 'Continue with email',
        ),
        SizedBox(height: compact ? 10 : 12),
        InkWell(
          onTap: () => context.push(AppRouter.kAuthSignIn),
          child: Text(
            'I alredy have an Account',
            style: TextStyle(
              color: AppColor.primaryColor,
              decoration: TextDecoration.underline,
              decorationColor: AppColor.primaryColor,
              fontSize: context.fs(14),
            ),
          ),
        ),
      ],
    );
  }
}
