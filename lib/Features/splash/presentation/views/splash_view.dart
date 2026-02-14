import 'package:adv/Features/splash/presentation/views/widgets/splash_view_body.dart';
import 'package:adv/core/exports/main_exports.dart';

import 'controller/splash_controller.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
 //   final SplashController controller = Get.put(SplashController());
    return const Scaffold(
      backgroundColor: Colors.white,
      body: SplashViewBody(),
    );
  }
}
