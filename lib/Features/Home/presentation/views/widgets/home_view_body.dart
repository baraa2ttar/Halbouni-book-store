import 'package:adv/core/constant/app_assets.dart';
import 'package:adv/core/constant/app_text_styles.dart';
import 'package:adv/core/exports/main_exports.dart';
import 'package:adv/core/exports/ui_exports.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'CustomDetailedBookBuilder.dart';
import 'FeaturedListView.dart';
import 'custom_app_bar.dart';
import 'custom_detailed_book_item.dart';
import 'custom_list_view_item.dart';

class HomeViewBody extends StatelessWidget {
  const HomeViewBody({super.key});
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8),
                child: const CustomAppBar(),
              ),
              // const CustomListViewItem(),
              FeaturedBooksListView(),
              const SizedBox(height: 40),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  "Best Seller ",
                  style: AppTextStyles.titleText(context),
                ),
              ),
              SizedBox(height: 20),
            ],
          ),
        ),
        SliverFillRemaining(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30),
              child: CustomDetailedBookBuilder(),
            )),
      ],
    );
  }
}
