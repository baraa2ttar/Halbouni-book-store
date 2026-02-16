import 'package:adv/Features/Home/presentation/views/widgets/rating_widget.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../../../../core/exports/main_exports.dart';
import '../../../../../core/exports/ui_exports.dart';

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

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: const Text(
                    "Legende de Paul thibault",
                    style: AppTextStyles.textStyle20,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 3),
                Text("J.K Rowling", style: AppTextStyles.textStyle14),
                const SizedBox(height: 3),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '19.99 \$',
                      style: AppTextStyles.textStyle20.copyWith(
                        fontWeight: FontWeight.bold,
                        fontFamily: kGtSectraFine,
                      ),
                    ),
                    RatingWidget(),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
