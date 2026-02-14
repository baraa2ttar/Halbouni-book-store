import 'package:adv/Features/Home/presentation/views/widgets/home_view_body.dart';
import 'package:adv/core/exports/main_exports.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: HomeViewBody(),
    );
  }
}
