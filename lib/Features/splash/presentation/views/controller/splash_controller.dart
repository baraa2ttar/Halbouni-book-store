import 'package:adv/view/onboarding/screens/onboarding_screen.dart';
import 'package:adv/core/exports/ui_exports.dart';

import '../../../../../core/services/services.dart';


class SplashController extends GetxController {
  final StorageService _storageService = StorageService();

  @override
  void onInit() {
    super.onInit();
    _navigateAfterSplash();
  }

  Future<void> _navigateAfterSplash() async {
    await Future.delayed(Duration(seconds: 3));

    bool isFirstLaunch = await _storageService.isFirstLaunch();

    if (isFirstLaunch) {
      await _storageService.setFirstLaunchFalse();
      Get.off(() => OnboardingScreen());
    } else {
      Get.off(() => OnboardingScreen());
    }
  }
}
