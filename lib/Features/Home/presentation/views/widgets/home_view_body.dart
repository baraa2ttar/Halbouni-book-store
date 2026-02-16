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
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CustomAppBar(),
          // const CustomListViewItem(),
          FeaturedBooksListView(),
          const SizedBox(height: 40),
          Text("Explore by Genre", style: AppTextStyles.titleText(context)),
          SizedBox(height: 20),
          CustomDetailedBookItem(),
        ],
      ),
    );
  }
}

class CustomDetailedBookItem extends StatelessWidget {
  const CustomDetailedBookItem({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 125,
      child: Row(
        children: [
          AspectRatio(
            aspectRatio: 2.5 / 4,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                image: DecorationImage(
                  image: Image.asset(AppAssets.book3).image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          const SizedBox(width: 30),

          Column(
            children: [
              SizedBox(
                width: MediaQuery.of(context).size.width *  0.5,
                child: const Text(
                  "Legende de Paul thibault",
                  style: AppTextStyles.textStyle20,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
