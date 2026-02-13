import 'package:adv/Features/splash/presentation/views/widgets/sliding_text.dart';
import 'package:adv/core/exports/main_exports.dart';

import '../../../../../core/constant/app_assets.dart';
import '../../../../../core/constant/app_text_styles.dart';

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
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(minutes: 1),
    );
    slidingAnimation = Tween<Offset>(
      begin: const Offset(0, 2),
      end: Offset.zero,
    ).animate(animationController);

  }
@override
void dispose(){
super.dispose();
animationController.dispose();
}
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
          SlidingText(slidingAnimation: slidingAnimation,slidingText: "Book Store ",),
        ],
      ),
    );
  }
}

