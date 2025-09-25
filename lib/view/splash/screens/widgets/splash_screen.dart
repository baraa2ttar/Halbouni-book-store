import 'package:adv/core/exports/ui_exports.dart';
import 'package:adv/view/splash/controller/splash_controller.dart';

class SplashScreen extends StatelessWidget {
  SplashScreen({super.key});

  final SplashController controller = Get.put(SplashController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
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
            Text(
              'Book Store',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
