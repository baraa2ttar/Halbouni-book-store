import 'package:adv/Features/Home/presentation/views/widgets/rating_widget.dart';
import 'package:adv/core/constant/app_text_styles.dart';
import 'package:adv/core/exports/main_exports.dart';

import 'custom_book_detailes_app_bar.dart';
import 'custom_list_view_item.dart';

class BookDetailsViewBody extends StatelessWidget {
  const BookDetailsViewBody({super.key});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center
        ,
        children: [
          SafeArea(child: CustomBookDetailesAppBar()),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.18),
            child: CustomListViewItem(),
          ),
          SizedBox(
            height: 43,
          ),
          Text(
            "The Jungle Book ",
            style: AppTextStyles.textStyle30,
          ),
          SizedBox(
            height: 6,
          ),
          Opacity(
            opacity: 0.7,
            child: Text(
              "Rudyard kipling",
              style: AppTextStyles.textStyle18.copyWith(
                 fontStyle: FontStyle.italic
                ),
            ),
          ),

        ],
      ),
    );
  }
}
