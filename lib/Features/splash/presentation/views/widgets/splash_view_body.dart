import 'package:adv/Features/splash/presentation/views/widgets/sliding_text.dart';
import 'package:adv/core/exports/main_exports.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../../../core/constant/app_assets.dart';
import '../../../../../core/constant/app_text_styles.dart';
import '../../../../../core/services/setup_service_locator.dart';
import '../../../../onboarding/domain/use_cases/is_onboarding_completed_use_case.dart';

class SplashViewBody extends StatefulWidget {
  const SplashViewBody({super.key});

  @override
  State<SplashViewBody> createState() => _SplashViewBodyState();
}

class _SplashViewBodyState extends State<SplashViewBody>
    with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<Offset> slidingAnimation;

  @override
  void initState() {
    super.initState();

    initSlidingAnimaiton();

    navigateToHome();
  }



  @override
  void dispose() {
    super.dispose();
    animationController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            AppAssets.appLogo,
            height: 120.h,
            width: 120.w,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 20.h),
          Text('Halbouni', style: AppTextStyles.headline(context)),
          SizedBox(height: 10.h),
          SlidingText(
            slidingAnimation: slidingAnimation,
            slidingText: "Book Store ",
          ),
        ],
      ),
    );
  }



  void initSlidingAnimaiton() {
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    slidingAnimation = Tween<Offset>(
      begin: const Offset(0, 2),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: animationController,
      curve: Curves.easeOut,
    ));
    animationController.forward();
  }
  void navigateToHome() {
    Future.delayed(const Duration(seconds: 2), () async {
      final isCompleted = await getIt.get<IsOnboardingCompletedUseCase>()();
      if (!mounted) return;

      final hydratedSession = Supabase.instance.client.auth.currentSession;
      _observeHydratedSupabaseSession(hydratedSession);

      AppRouter.router.go(
        isCompleted ? AppRouter.kHomeView : AppRouter.kOnboardingView,
      );
    });
  }

  /// Reads `currentSession` so cold start explicitly accounts for supabase_flutter's restored session (default local persistence after [Supabase.initialize]).
  void _observeHydratedSupabaseSession(Session? session) {
    if (session == null) {
      return;
    }
    // Non-null: user can skip re-entering credentials; splash still routes by local onboarding completion only.
  }
}
