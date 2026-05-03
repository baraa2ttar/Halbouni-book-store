import 'package:adv/Features/Home/presentation/views/widgets/custom_book_image_loading_indicator.dart';
import 'package:adv/core/widgets/custom_fading_widget.dart';

import '../../../../../core/exports/main_exports.dart';

class FeaturedBookListViewLoadingIndicator extends StatelessWidget {
  const FeaturedBookListViewLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return CustomFadingWidget(
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.3,
        child: ListView.builder(
      
          itemCount:15,
          scrollDirection: Axis.horizontal,
          itemBuilder: (context, index) {
           
              return const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Center(
                  child: SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  ),
                ),
              );
      
      
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: CustomBookImageLoadingIndicator()
            );
          },
        ),
      ),
    );
  }
}
