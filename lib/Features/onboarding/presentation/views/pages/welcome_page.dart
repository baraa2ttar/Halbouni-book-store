import 'package:adv/core/exports/ui_exports.dart';
import 'package:adv/core/widgets/responsive_layout.dart';

import '../widgets/welcome_content.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key, required this.onGetStarted});

  final VoidCallback onGetStarted;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
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
          ),
          SafeArea(
            child: ResponsiveLayout(
              mobile: (context) => _WelcomeMobileLayout(onGetStarted: onGetStarted),
              tablet: (context) => _WelcomeTabletLayout(onGetStarted: onGetStarted),
              laptop: (context) => _WelcomeLaptopLayout(onGetStarted: onGetStarted),
            ),
          ),
        ],
      ),
    );
  }
}

class _WelcomeMobileLayout extends StatelessWidget {
  const _WelcomeMobileLayout({required this.onGetStarted});

  final VoidCallback onGetStarted;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final topSpacer = (constraints.maxHeight * 0.38).clamp(120.0, 420.0);

        return SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.symmetric(horizontal: context.horizontalPadding),
          child: ConstrainedBox(
            constraints: BoxConstraints(minHeight: constraints.maxHeight),
            child: Column(
              children: [
                SizedBox(height: topSpacer),
                WelcomeContent(onGetStarted: onGetStarted),
                SizedBox(height: context.ph(16)),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _WelcomeTabletLayout extends StatelessWidget {
  const _WelcomeTabletLayout({required this.onGetStarted});

  final VoidCallback onGetStarted;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.horizontalPadding),
      child: Row(
        children: [
          Expanded(
            flex: 5,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 48),
                child: Text(
                  'Discover your next favorite book',
                  style: TextStyle(
                    fontSize: context.fs(28),
                    fontWeight: FontWeight.w700,
                    color: AppColor.titleColor,
                    height: 1.3,
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: context.contentMaxWidth),
                child: WelcomeContent(onGetStarted: onGetStarted),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _WelcomeLaptopLayout extends StatelessWidget {
  const _WelcomeLaptopLayout({required this.onGetStarted});

  final VoidCallback onGetStarted;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: context.horizontalPadding),
          child: Row(
            children: [
              Expanded(
                flex: 6,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Welcome to Halbouni',
                      style: TextStyle(
                        fontSize: context.fs(40),
                        fontWeight: FontWeight.w800,
                        color: AppColor.titleColor,
                        height: 1.2,
                      ),
                    ),
                    SizedBox(height: context.ph(16)),
                    Text(
                      'The first online book store application in Syria. '
                      'Browse, discover, and order books tailored to your interests.',
                      style: TextStyle(
                        fontSize: context.fs(18),
                        color: AppColor.darkGreyColor,
                        height: 1.5,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 5,
                child: Center(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(maxWidth: context.contentMaxWidth),
                    child: WelcomeContent(onGetStarted: onGetStarted),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
