import 'package:adv/core/constant/app_assets.dart';
import 'package:adv/core/exports/main_exports.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'custom_app_bar.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
const CustomAppBar()
      ],
    );
  }

}
