import 'package:adv/core/constant/app_assets.dart';
import 'package:adv/core/constant/app_text_styles.dart';
import 'package:adv/core/exports/main_exports.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'FeaturedListView.dart';
import 'custom_app_bar.dart';
import 'custom_list_view_item.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
          children: [
        const CustomAppBar(),
      // const CustomListViewItem(),
        FeaturedBooksListView(),
        const SizedBox(height: 40,),
        Text("Explore by Genre",
        style: AppTextStyles.titleText(context),
        )

      ]),
    );

  }
}
