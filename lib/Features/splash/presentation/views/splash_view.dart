import 'package:adv/Features/splash/presentation/views/widgets/splash_view_body.dart';
import 'package:adv/core/exports/main_exports.dart';

class SplashView extends StatelessWidget {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return const  Scaffold(body:
      SplashViewBody(),
      );
  }
}
